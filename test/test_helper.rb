require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'
$TESTING = true
require 'test/unit'
require 'mail_gate'

class Test::Unit::TestCase
  # Return a stubbed mail object helpful for writing unit tests.
  #
  # options - The Hash options used to refine the selection (default: {}):
  #           :whitelist      - The Regex to match against emails (optional).
  #           :subject_prefix - The String to be prepended to the subject (optional).
  #           :from           - The email responsible for sending the email (optional) (default: test@mail_gate.com).
  #           :to             - The Array or String of emails for the to field (optional).
  #           :cc             - The Array or String of emails for the cc field (optional).
  #           :bcc            - The Array or String of emails for the bcc field (optional).
  #
  # Examples
  #
  #   mail = with_whitelist :to => 'test@email.com'
  #   # => #<Mail::Message to: "test@email.com">
  #
  # Returns instance of Mail::Message.
  def with_whitelist(options={})
    filter = MailGate::Filter.new \
      :whitelist => options.fetch(:whitelist, /.*/),
      :subject_prefix => options.delete(:subject_prefix),
      :append_emails => options.delete(:append_emails)

    mail = Mail.new options.merge(:from => 'test@mail_gate.com')

    filter.deliver!(mail)
  end
end

Mail.defaults do
  delivery_method :test
end

