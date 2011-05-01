module ROTP
  class Base32
    CHARS = "abcdefghijklmnopqrstuvwxyz234567".each_char.to_a

    class << self
      def decode(str)
        output = []
        str.scan(/.{8}/).each do |block|
          char_array = decode_block(block).map{|c| c.chr}
          output << char_array
        end
        output.join
      end

      def random_base32(length=16)
        b32 = ''
        OpenSSL::Random.random_bytes(length).each_byte do |b|
          b32 << CHARS[b % 32]
        end
        b32
      end

      private

      def decode_block(block)
        return 0 unless (block.bytesize % 8 == 0) || (block.bytesize == 0)
        length = block.scan(/[^=]/).length
        quints = block.each_char.map {|c| decode_quint(c)}
        bytes = []
        bytes[0] = (quints[0] << 3) + (quints[1] >> 2)
        return bytes if length < 3
        bytes[1] = ((quints[1] & 3) << 6) + (quints[2] << 1) + (quints[3] >> 4)
        return bytes if length < 5
        bytes[2] = ((quints[3] & 15) << 4) + (quints[4] >> 1)
        return bytes if length < 6
        bytes[3] = ((quints[4] & 1) << 7) + (quints[5] << 2) + (quints[6] >> 3)
        bytes[4] = ((quints[6] & 7) << 5) + quints[7]
        bytes
      end

      def decode_quint(q)
        CHARS.index(q.downcase)
      end

    end

  end
end
