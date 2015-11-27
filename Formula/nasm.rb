class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "http://www.nasm.us/"
  revision 1

  stable do
    url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/nasm-2.11.08.tar.xz"
    sha256 "c99467c7072211c550d147640d8a1a0aa4d636d4d8cf849f3bf4317d900a1f7f"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/7a329c65e/nasm/nasm_outmac64.patch"
      sha256 "54bfb2a8e0941e0108efedb4a3bcdc6ce8dff0d31d3abdf2256410c0f93f5ad7"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "46bac3d011b8dcfc4874eac8f99af92cef26bbecc486beed6fe809b63d77ca87" => :el_capitan
    sha256 "4b7434920425f190c807863d79f653d1f3a8668916f5780a5f2c529056d714b9" => :yosemite
    sha256 "dbcbfe3dd3f67dce50f6baf2a0aea7021f4c893863b4ed552542685488519b38" => :mavericks
    sha256 "0191f8c219a08f1a3207d63e07b736b627f90d80373d400bded4cada29afc184" => :mountain_lion
  end

  devel do
    url "http://www.nasm.us/pub/nasm/releasebuilds/2.11.09rc1/nasm-2.11.09rc1.tar.xz"
    sha256 "8b76b7f40701a5bdc8ef29fc352edb0714a8e921b2383072283057d2b426a890"
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "install_rdf"
  end

  test do
    (testpath/"foo.s").write <<-EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
