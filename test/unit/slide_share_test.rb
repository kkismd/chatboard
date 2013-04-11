# coding: utf-8
require 'test_helper'

class SlideShareTest < ActiveSupport::TestCase
  setup do
  end

  teardown do
  end

  test 'オブジェクトを作成できる' do
    url = ''
    slideshare = SlideShare.new(url)

    assert_kind_of SlideShare, slideshare
  end

  #context 'URLをチェックできる' do
  #  test '不正なURL' do
  #    slideshare = SlideShare.new('')
  #    assert  slideshare.valid?
  #  end
  #
  #end

  test 'success test' do
    assert_equal 1, 1
  end
end