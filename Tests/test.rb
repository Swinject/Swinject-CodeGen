require "minitest/autorun"
require "minitest/reporters"


reporter_options = { color: true }
default_reporter = Minitest::Reporters::DefaultReporter.new(reporter_options)
Minitest::Reporters.use! [default_reporter]

# code generation tests
class TestCodegeneration < Minitest::Test
  def build_csv(file_name)
    `./../bin/swinject_codegen -i #{file_name}`.chomp
  end

  def read_file(file_name)
    File.read(file_name).chomp
  end

  def run_test(base_file_name)
    output = build_csv("Examples/#{base_file_name}.csv")
    example = read_file("ExpectedCode/#{base_file_name}.swift")
    assert_equal output, example
  end

  def test_example_a
    run_test("ExampleA")
  end

  def test_example_b
    run_test("ExampleB")
  end

  def test_example_c
    run_test("ExampleC")
  end

  def test_example_d
    run_test("ExampleD")
  end

  def test_example_e
    run_test("ExampleE")
  end

  def test_example_f
    run_test("ExampleF")
  end

  def test_bug_50
    outputA = build_csv("Examples/bug_50_A.csv")
    outputB = build_csv("Examples/bug_50_B.csv")
    assert_equal outputA, outputB
  end

  def test_Bug_51
    outputA = build_csv("Examples/Bug_51_A.csv")
    outputB = build_csv("Examples/Bug_51_B.csv")
    assert_equal outputA, outputB
  end
end
