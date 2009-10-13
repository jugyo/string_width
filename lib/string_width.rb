module StringWdth
  UNICODE_WIDTH_DATA = {}
  WIDE_CHAR_DATA = {}

  def self.included(base)
    base.send(:include, InstanceMethods)

    File.open(File.join(File.dirname(__FILE__), 'EastAsianWidth.txt')).each do |file|
      file.each_line do |line|
        next if line =~ /^#/
        if line =~ /([0-9ABCDEF]+);(\w+)/
          code, type = $1.to_i(16), $2
          UNICODE_WIDTH_DATA[code] = type
        end
      end
    end

    WIDE_CHAR_DATA['CJK Unified Ideographs Extension A']      = 0x3400..0x4DBF
    WIDE_CHAR_DATA['CJKCJK Unified Ideographs']               = 0x4E00..0x9FFF
    WIDE_CHAR_DATA['CJK Compatibility Ideographs']            = 0xF900..0xFAFF
    WIDE_CHAR_DATA['Hangul Syllable']                         = 0xAC00..0xD7A3
    WIDE_CHAR_DATA['CJK Unified Ideographs Extension B']      = 0x20000..0x2A6DF
    WIDE_CHAR_DATA['CJK Unified Ideographs Extension C']      = 0x2A700..0x2B73F
    WIDE_CHAR_DATA['CJK Compatibility Ideographs Supplement'] = 0x2F800..0x2FA1F
    WIDE_CHAR_DATA['<reserved-4DB6>..<reserved-4DBF>']        = 0x4DB6..0x4DBF
    WIDE_CHAR_DATA['<reserved-9FCC>..<reserved-9FFF>']        = 0x9FCC..0x9FFF
    WIDE_CHAR_DATA['<reserved-FA2E>..<reserved-FA2F>']        = 0xFA2E..0xFA2F
    WIDE_CHAR_DATA['<reserved-FA6E>..<reserved-FA6F>']        = 0xFA6E..0xFA6F
    WIDE_CHAR_DATA['<reserved-FADA>..<reserved-FAFF>']        = 0xFADA..0xFAFF
    WIDE_CHAR_DATA['<reserved-2A6D7>..<reserved-2A6FF>']      = 0x2A6D7..0x2A6FF
    WIDE_CHAR_DATA['<reserved-2B735>..<reserved-2F7FF>']      = 0x2B735..0x2F7FF
    WIDE_CHAR_DATA['<reserved-2FA1E>..<reserved-2FFFD>']      = 0x2FA1E..0x2FFFD
    WIDE_CHAR_DATA['<reserved-30000>..<reserved-3FFFD>']      = 0x30000..0x3FFFD
  end

  module InstanceMethods
    # encoding should be UTF-8
    def width
      self.split(//u).inject(0) do |total_width, char|
        code = char.unpack('U*').first
        width_type = UNICODE_WIDTH_DATA[code]
        char_width =
          case width_type
          when 'W', 'F'
            2
          else
            if WIDE_CHAR_DATA.values.any? { |i| i.include?(code) }
              2
            else
              1
            end
          end
        total_width + char_width
      end
    end
  end
end

class String
  include StringWdth
end