require 'minitest/autorun'
require 'lasagna'

class LasagnaTest < Minitest::Test
  def test_empty
    json = {}
    assert_equal Lasagna.parse(json), {}
  end

  def test_no_data
    json = { 'no_data' => 10 }
    assert_equal Lasagna.parse(json), {}
  end

  def test_empty_data
    json = { 'data' => [
        { 'id' => 1,
          'type' => 'comment',
          'attributes' => {
              'created' => '1900-10-10',
              'title' => 'title',
              'text' => 'content'
          }}
    ] }

    expected = {
        'id' => 1,
        'type' => 'comment',
        'created' => '1900-10-10',
        'title' => 'title',
        'text' => 'content'
    }
    assert_equal Lasagna.parse(json)[0], expected
  end

  def test_options
    json = { 'data' => [
        { 'id' => 1,
          'type' => 'comment',
          'attributes' => {
              'title' => 'title'
          }}
    ] }

    expected = {
        'title' => 'title'
    }

    options = { include_ids: false,
                include_types: false }
    assert_equal Lasagna.parse(json, options)[0], expected
  end

  def test_relationships
    json = { 'data' => [
        { 'id' => 1,
          'type' => 'comment',
          'attributes' => { 'created' => '1900-10-10',
                            'title' => 'comment_title',
                            'text' => 'comment_content' },

          'relationships' => {
              'post' => { 'data' => { 'id' => 11,
                                      'type' => 'post' } } }
        }],

        'included' => [{
            'id' => 11,
            'type' => 'post',
            'attributes' => { 'created' => '1900-09-09',
                              'title' => 'post_title',
                              'text' => 'post_content' } }] }

    expected = {
        'id' => 1,
        'type' => 'comment',
        'created' => '1900-10-10',
        'title' => 'comment_title',
        'text' => 'comment_content',
        'post' => {
            'id' => 11,
            'type' => 'post',
            'created' => '1900-09-09',
            'title' => 'post_title',
            'text' => 'post_content'
        }
    }

    assert_equal Lasagna.parse(json)[0], expected
  end

end
