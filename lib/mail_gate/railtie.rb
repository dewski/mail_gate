module MailGate
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      ActionMailer::Base.add_delivery_method :mail_gate, MailGate::Filter
    end
  end
end
