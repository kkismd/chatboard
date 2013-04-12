# coding: utf-8
require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  setup do
  end

  teardown do
  end

  test 'オブジェクトを作成できる' do
    url = ''
    slide = Slide.new(url)

    assert_kind_of Slide, slide
  end

  test '不正なURL' do
    slide = Slide.new('')
    assert !slide.valid?
  end

  test 'slideshare' do
    slide = Slide.new('http://www.slideshare.net/t_wada/devlove2012-twada-tdd')
    assert slide.valid?
  end

  test 'googledocs' do
    slide = Slide.new('https://docs.google.com/presentation/d/1azeKfXrSJ8nRlFeMoqBIQXbRtYXX4Mk50TrJDHAh4bA/edit#slide=id.p')
    assert slide.valid?
  end
end