require File.expand_path('../../../spec_helper', __FILE__)
require 'strscan'

describe "StringScanner#getch" do
  before :each do
    @kcode = $KCODE
  end

  after :each do
    $KCODE = @kcode
  end

  it "scans one character and returns it" do
    s = StringScanner.new('abc')
    s.getch.should == "a"
    s.getch.should == "b"
    s.getch.should == "c"
  end

  it "is multi-byte character sensitive" do
    $KCODE = 'EUC'

    # Japanese hiragana "A" in EUC-JP
    src = encode("\244\242", "euc-jp")

    s = StringScanner.new(src)
    s.getch.should == src
  end

  it "returns nil at the end of the string" do
    # empty string case
    s = StringScanner.new('')
    s.getch.should == nil
    s.getch.should == nil

    # non-empty string case
    s = StringScanner.new('a')
    s.getch # skip one
    s.getch.should == nil
  end

  it "always returns instance of String, never a String subclass" do
    cls = Class.new(String)
    sub = cls.new("abc")

    s = StringScanner.new(sub)
    ch = s.getch
    ch.should_not be_kind_of(cls)
    ch.should == "a"
  end
end
