require 'test_helper'

class YamlEnumeration::EnumerationTest < Minitest::Test

  class EnumerationExample < YamlEnumeration::Enumeration
    value :id => 1, :type => 'first',  :name => 'First',  :flagged => true
    value :id => 2, :type => 'second', :name => 'Second', :flagged => false
    value :id => 5, :type => 'third',  :name => 'Third'

    with_named_items
  end

  context "all enumerations" do
    should "work" do
      assert_equal 3, EnumerationExample.all.size
      assert EnumerationExample.all.include?(EnumerationExample.find(1))
      assert EnumerationExample.all.include?(EnumerationExample.find(2))
      assert EnumerationExample.all.include?(EnumerationExample.find(5))
    end
  end

  context 'finding enumerations' do
    should 'work' do
      first = EnumerationExample.find(1)
      assert_equal 1, first.id
      assert_equal 'first', first.type
      assert_nil EnumerationExample.find(3)

      second = EnumerationExample.find_by_id(2)
      assert_equal 2, second.id
      assert_equal 'second', second.type
      assert_nil EnumerationExample.find_by_id(3)

      third = EnumerationExample.find_by_type('third')
      assert_equal 5, third.id
      assert_equal 'third', third.type
      assert_nil EnumerationExample.find_by_type('unknown')
    end
  end

  context 'accessor methods' do
    should 'work' do
      first = EnumerationExample.find(1)
      assert_equal 1, first.id
      assert_equal 'first', first.type
      assert_equal 'First', first.name
      assert first.flagged
      assert first.flagged?
      first.flagged = false
      assert !first.flagged
      assert !first.flagged?

      second = EnumerationExample.find(2)
      assert !second.flagged
      assert !second.flagged?

      third = EnumerationExample.find(5)
      assert_nil third.flagged
      assert_equal false, third.flagged?
    end
  end

  context 'named items' do
    should 'access their corresponding records' do
      assert_equal 'First', EnumerationExample.FIRST.name
      assert_equal 'Second', EnumerationExample.SECOND.name
      assert_equal 'Third', EnumerationExample.THIRD.name
    end
  end

  context "comparison" do
    should 'work' do
      enum = EnumerationExample.find(1)
      assert enum == EnumerationExample.find(1)
      assert enum != EnumerationExample.find(2)
    end
  end

  context 'find_by' do
    should 'find a single item by a field' do
      assert_equal EnumerationExample.find(2), EnumerationExample.find_by(:type, 'second')
      assert_equal EnumerationExample.find(2), EnumerationExample.find_by(type: 'second')
    end

    should 'find a single item by a case insensitive field' do
      assert_equal EnumerationExample.find(3), EnumerationExample.find_by(:name, 'third')
      assert_equal EnumerationExample.find(3), EnumerationExample.find_by(name: 'third')
    end

    should 'return nil for no match' do
      assert_nil EnumerationExample.find_by(:name, 'meh')
      assert_nil EnumerationExample.find_by(name: 'meh')
    end
  end

  context 'where' do
    should 'find a single item by a field' do
      assert_equal [ EnumerationExample.find(2) ], EnumerationExample.where(type: 'second')
    end

    should 'return empty array for no match' do
      assert_empty EnumerationExample.where(name: 'meh')
    end
  end
end
