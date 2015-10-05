describe Bismas::Parser do

  subject { described_class.new(strict: true) }

  def self.expect_parse_error(msg, input)
    example { expect{subject.parse(StringIO.new(*encode(input)))}
      .to(raise_error(described_class::ParseError, /\A#{msg}/)) }
  end

  expect_parse_error('Malformed record', "foo\r\n")
  expect_parse_error('Unexpected data',  "\x010\r\n")
  expect_parse_error('Unclosed field',   "\x01000\r\n")
  expect_parse_error('Unclosed field',   "\x01foo\r\n")
  expect_parse_error('Malformed field',  "\x01foo\x00\r\n")
  expect_parse_error('Malformed record', "\x01\r\nfoo\r\n")
  expect_parse_error('Malformed record', "\x01\r\nfoo\r\n000")

end
