require 'minitest/autorun'

class TestCodegeneration < Minitest::Test
  def buildCSV(fileName)
    %x(./../bin/swinject_codegen -i #{fileName}).chomp
  end

  def readFile(fileName)
    File.read(fileName).chomp
  end

  def runTest(baseFileName)
    assert_equal buildCSV("Examples/#{baseFileName}.csv"), readFile("ExpectedCode/#{baseFileName}.swift")
  end

  def test_example_a
    runTest("ExampleA")
  end

  def test_example_b
    runTest("ExampleB")
  end

  def test_example_c
    runTest("ExampleC")
  end

  def test_example_d
    runTest("ExampleD")
  end

  def test_example_e
    runTest("ExampleE")
  end

  def test_example_f
    runTest("ExampleF")
  end
end
