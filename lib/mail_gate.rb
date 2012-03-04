require 'mail_gate/version'
require 'mail_gate/railtie' if defined?(Rails)

module MailGate
  autoload :Filter, 'mail_gate/filter'
end
