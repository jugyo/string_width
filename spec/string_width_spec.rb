require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "StringWdth" do
  test_data = {
    'a' => 1,
    'A' => 1,
    'あ' => 2,
    'ぁ' => 2,
    'ｱ' => 1,
    '！' => 2,
    'テスト' => 6,
    '10月14日' => 8,
    '㐀' => 2,
    '豈' => 2,
    '一' => 2,
    '丽' => 2,
    '������' => 2,
    '䶶' => 2, # U+4DB6
  }
  test_data.each do |k, v|
    it "size of '#{k}' is #{v}" do
      k.width.should == v
    end
  end
end
