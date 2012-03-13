require 'test_helper'

class TestFilter < Test::Unit::TestCase
  def test_without_whitelist_regex
    mail = with_whitelist :to => 'garrett@site.com'
    assert_equal %w{ garrett@site.com }, mail.to
  end

  def test_with_whitelist_as_string
    mail = with_whitelist \
      :to => 'garrett@site.com',
      :whitelist => '@site.com'
    assert_equal %w{ garrett@site.com }, mail.to
  end

  def test_with_no_matching_whitelist
    mail = with_whitelist \
      :to => 'garrett@site.com',
      :whitelist => /cnn.com/
    assert mail.to.blank?, 'no mail values'
  end

  def test_to_field_whitelisted_emails
    mail = with_whitelist \
      :to => %w{ garrett@site.com matt@site.com non-staff@user.com },
      :whitelist => /site.com/

    assert_equal %w{ garrett@site.com matt@site.com }, mail.to
  end

  def test_to_field_domain_and_user_whitelist
    mail = with_whitelist \
      :to => %w{ garrett@site.com someone@special.com },
      :whitelist => /site.com|someone@special.com/

    assert_equal %w{ garrett@site.com someone@special.com }, mail.to
  end

  def test_cc_field_domain_and_user_whitelist
    mail = with_whitelist \
      :to => %w{ garrett@site.com matt@site.com },
      :cc => 'george@whitehouse.gov',
      :whitelist => /site.com/

    assert_equal %w{ garrett@site.com matt@site.com }, mail.to
    assert mail.cc.blank?, 'no cc field'
  end

  def test_bcc_field_domain_and_user_whitelist
    mail = with_whitelist \
      :to => %w{ garrett@site.com matt@site.com },
      :bcc => 'luke@skywalker.com',
      :whitelist => /site.com/

    assert_equal %w{ garrett@site.com matt@site.com }, mail.to
    assert mail.cc.blank?, 'no cc field'
    assert mail.bcc.blank?, 'no bcc field'
  end

  def test_bcc_field_domain_and_user_whitelist
    mail = with_whitelist \
      :to => %w{ garrett@site.com matt@site.com },
      :bcc => %w{ luke@skywalker.com luke@copy.com },
      :whitelist => /site.com|copy.com/

    assert_equal %w{ garrett@site.com matt@site.com }, mail.to
    assert_equal %w{ luke@copy.com }, mail.bcc
  end

  def test_settings_prefix
    mail = with_whitelist \
      :to => 'garrett@site.com',
      :subject => 'Welcome to the site!',
      :subject_prefix => '[staging] '

    assert_equal '[staging] Welcome to the site!', mail.subject
  end

  def test_append_emails_is_included
    mail = with_whitelist \
      :to => %w{ garrett@site.com matt@site.com luke@skywalker.com luke@copy.com },
      :bcc => 'garrett@example.com',
      :body => 'Test',
      :whitelist => /site.com|copy.com/

    assert_match /luke@skywalker.com\, garrett@example.com$/, mail.body.to_s
  end

  def test_appended_emails_not_included
    mail = with_whitelist \
      :to => %w{ garrett@site.com matt@site.com luke@skywalker.com luke@copy.com },
      :bcc => 'garrett@example.com',
      :body => 'Test',
      :whitelist => /site.com|copy.com/,
      :append_emails => false

    assert_no_match /Extracted Recipients/, mail.body.to_s
  end
end
