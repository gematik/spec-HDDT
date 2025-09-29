#!/usr/bin/env ruby
# frozen_string_literal: true
# Usage: ruby _decorateKeywords.rb path/to/file.md

abort("Usage: #{File.basename($0)} path/to/file.md") if ARGV.length != 1
in_path = ARGV[0]
abort("File not found: #{in_path}") unless File.exist?(in_path)

# ---------- Encoding helpers ----------
def detect_encoding(bytes)
  return ["UTF-8", [0xEF,0xBB,0xBF]]         if bytes[0,3] == [0xEF,0xBB,0xBF]
  return ["UTF-32LE", [0xFF,0xFE,0x00,0x00]] if bytes[0,4] == [0xFF,0xFE,0x00,0x00]
  return ["UTF-32BE", [0x00,0x00,0xFE,0xFF]] if bytes[0,4] == [0x00,0x00,0xFE,0xFF]
  return ["UTF-16LE", [0xFF,0xFE]]           if bytes[0,2] == [0xFF,0xFE]
  return ["UTF-16BE", [0xFE,0xFF]]           if bytes[0,2] == [0xFE,0xFF]
  s = bytes.pack("C*").force_encoding("UTF-8")
  s.valid_encoding? ? ["UTF-8", []] : ["Windows-1252", []]
end
def decode(bytes)
  enc_name, bom = detect_encoding(bytes)
  data = bom.empty? ? bytes : bytes[bom.length..-1]
  txt  = (data || []).pack("C*").force_encoding(enc_name).encode("UTF-8")
  [txt, enc_name, bom]
end
def encode_back(utf8, enc_name, bom)
  if enc_name == "UTF-8"
    (bom + utf8.encode("UTF-8").bytes).pack("C*")
  else
    utf8.encode(enc_name, undef: :replace, replace: "?")
  end
end

# ---------- Protected regions ----------
FENCE_RE       = Regexp.new('(^|\n)(`{3,}|~{3,})[^\n]*\n.*?\n\2[ \t]*\n?', Regexp::MULTILINE)
INLINE_LINK_RE = Regexp.new('!?\[[^\]]*\]\([^)]+\)')
INLINE_CODE_RE = Regexp.new('`[^`]*`')
REFLINK_DEF_RE = Regexp.new('^[ \t]*\[[^\]]+\]:[ \t]+\S+[^\n]*$', Regexp::MULTILINE)

def merge_ranges(ranges)
  rs = ranges.sort_by(&:first)
  out = []
  rs.each do |a,b|
    if out.empty? || a > out[-1][1]
      out << [a,b]
    else
      out[-1][1] = [out[-1][1], b].max
    end
  end
  out
end
def overlaps_any?(ranges, a, b) = ranges.any? { |x,y| a < y && b > x }
def forbidden_ranges(text)
  ranges = []
  text.to_enum(:scan, FENCE_RE)       { ranges << [$~.offset(0)[0], $~.offset(0)[1]] }
  text.to_enum(:scan, INLINE_LINK_RE) { ranges << [$~.offset(0)[0], $~.offset(0)[1]] }
  text.to_enum(:scan, INLINE_CODE_RE) { ranges << [$~.offset(0)[0], $~.offset(0)[1]] }
  text.to_enum(:scan, REFLINK_DEF_RE) { ranges << [$~.offset(0)[0], $~.offset(0)[1]] }
  merge_ranges(ranges)
end

# ---------- Change recording & logging ----------
Change = Struct.new(:start, :finish, :before, :after, :kind)
def line_no_for(text, index) = text[0,index].count("\n") + 1
def sentence_for(text, start_idx, end_idx)
  i = start_idx - 1; b = 0
  while i >= 0
    ch = text[i]; if ch == '.' || ch == '!' || ch == '?' || ch == "\n"; b = i + 1; break; end
    i -= 1
  end
  j = end_idx; e = text.length
  while j < text.length
    ch = text[j]; if ch == '.' || ch == '!' || ch == '?' || ch == "\n"; e = j + 1; break; end
    j += 1
  end
  text[b...e].gsub(/\r?\n+/, ' ').gsub(/\s+/, ' ').strip
end

# ---------- Build changes on ORIGINAL text ----------
orig_bytes = File.binread(in_path).bytes
orig_utf8, enc_name, bom = decode(orig_bytes)
forbid = forbidden_ranges(orig_utf8)
changes = []

# RFC 2119 phrases
%w[must shall should].each do |head|
  patt = '(?<![A-Za-z0-9_])' \
         '(?:\*{1,3}|_{1,3})?\s*' + head +
         '\s*(?:\*{1,3}|_{1,3})?\s+' \
         '(?:\*{1,3}|_{1,3})?\s*not\s*(?:\*{1,3}|_{1,3})?' \
         '(?![A-Za-z0-9_])'
  re = Regexp.new(patt, Regexp::IGNORECASE)
  pos = 0
  while (m = re.match(orig_utf8, pos))
    a, b = m.begin(0), m.end(0)
    changes << Change.new(a, b, orig_utf8[a...b], "#{head.upcase} NOT", :rfc_phrase) unless overlaps_any?(forbid, a, b)
    pos = m.end(0)
  end
end

# RFC 2119 single keywords
single = %w[MUST SHALL SHOULD REQUIRED RECOMMENDED MAY OPTIONAL]
patt_single = '(?<![A-Za-z0-9_])(?:\*{1,3}|_{1,3})?\s*\b(' + single.join('|') + ')\b\s*(?:\*{1,3}|_{1,3})?(?![A-Za-z0-9_])'
re_single = Regexp.new(patt_single, Regexp::IGNORECASE)
pos = 0
while (m = re_single.match(orig_utf8, pos))
  a, b = m.begin(0), m.end(0)
  unless overlaps_any?(forbid, a, b) || changes.any? { |c| a < c.finish && b > c.start }
    changes << Change.new(a, b, orig_utf8[a...b], m[1].upcase, :rfc_single)
  end
  pos = m.end(0)
end

# FHIR linking — exact-case, preceded by space or start-of-line, not in headers
FHIR_RESOURCES = {
  "Bundle"              => "https://hl7.org/fhir/R4/bundle.html",
  "Composition"         => "https://hl7.org/fhir/R4/composition.html",
  "CapabilityStatement" => "https://hl7.org/fhir/R4/capabilitystatement.html",
  "Observation"         => "https://hl7.org/fhir/R4/observation.html",
  "OperationOutcome"    => "https://hl7.org/fhir/R4/operationoutcome.html",
  "StructureDefinition" => "https://hl7.org/fhir/R4/structuredefinition.html",
  "SearchParameter"     => "https://hl7.org/fhir/R4/searchparameter.html",
  "Device"              => "https://hl7.org/fhir/R4/device.html",
  "DeviceMetric"        => "https://hl7.org/fhir/R4/devicemetric.html",
  "ConceptMap"          => "https://hl7.org/fhir/R4/conceptmap.html",
  "ValueSet"            => "https://hl7.org/fhir/R4/valueset.html",
  "CodeSystem"          => "https://hl7.org/fhir/R4/codesystem.html",
  "OperationDefinition" => "https://hl7.org/fhir/R4/operationdefinition.html"
}.freeze
names_union = FHIR_RESOURCES.keys.sort_by { |k| -k.length }.map { |n| Regexp.escape(n) }.join('|')
re_fhir = Regexp.new('(^|(?<=\s))(' + names_union + ')(?![A-Za-z0-9_])', Regexp::MULTILINE)
header_line_re = Regexp.new('^[ \t]{0,3}#{1,6}[ \t]+')

pos = 0
while (m = re_fhir.match(orig_utf8, pos))
  a, b = m.begin(2), m.end(2)
  line_start = orig_utf8.rindex("\n", a - 1) || -1
  line_start += 1
  line_end = orig_utf8.index("\n", a) || orig_utf8.length
  line_text = orig_utf8[line_start...line_end]
  if header_line_re.match?(line_text)
    pos = m.end(0)
    next
  end
  unless overlaps_any?(forbid, a, b) || changes.any? { |c| a < c.finish && b > c.start }
    name = m[2]
    after = "[#{name}](#{FHIR_RESOURCES[name]})"
    changes << Change.new(a, b, orig_utf8[a...b], after, :fhir_link)
  end
  pos = m.end(0)
end

# De-overlap & apply
changes.sort_by!(&:start)
filtered = []
cursor = 0
changes.each do |c|
  next if c.start < cursor
  filtered << c
  cursor = c.finish
end
changes = filtered

out = +""
idx = 0
changes.each do |c|
  out << orig_utf8[idx...c.start]
  out << c.after
  idx = c.finish
end
out << orig_utf8[idx..-1].to_s
File.binwrite(in_path, encode_back(out, enc_name, bom))

# ---------- Grouped logs ----------
if changes.empty?
  puts "No changes."
else
  rfc = changes.select { |c| c.kind == :rfc_phrase || c.kind == :rfc_single }
  fhir = changes.select { |c| c.kind == :fhir_link }
  puts "#{changes.size} changes applied"
  puts "RFC Keywords (#{rfc.size}):"
  rfc.each do |c|
    ln = line_no_for(orig_utf8, c.start)
    puts "- #{ln}: #{sentence_for(orig_utf8, c.start, c.finish)} -> #{c.after}"
  end
  puts "FHIR Ressource Linkage (#{fhir.size}):"
  fhir.each do |c|
    ln = line_no_for(orig_utf8, c.start)
    puts "- #{ln}: #{sentence_for(orig_utf8, c.start, c.finish)} -> #{c.after}"
  end
end
