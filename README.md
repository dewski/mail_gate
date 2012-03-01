# MailGate

MailGate is an additional delivery method for the [Mail](https://github.com/mikel/mail) gem that lets you restrict the delivery of mail to only whitelisted emails. Ideal for staging environments and other situations where you may not want users of your application to recieve emails. Works with

## Installation

Add this line to your application's Gemfile:

    gem 'mail_gate'

And then run:

    $ bundle

Or install it yourself as:

    $ gem install mail_gate

## Usage

MailGate works as a standalone extension to the [Mail](https://github.com/mikel/mail) gem or as a delivery method within Rails applications.

An example use case would be if you're running say, CNN.com and you have a commenting system in place where once a comment is added to a post the author and other commenters are notified about your comment. You wouldn't want users to see recieve notifications from activity on your staging site, right? Your existing `config/environments/staging.rb` may look something like:

```ruby
CNN::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '25',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => ENV['SENDGRID_DOMAIN']
  }
end
```

Now just change your `delivery_method` to use `:mail_gate` then move your settings to `:delivery_settings` like shown below.

```ruby
CNN::Application.configure do
  config.action_mailer.delivery_method = :mail_gate
  config.action_mailer.mail_gate_settings = {
    :whitelist        => /cnn.com/,
    :subject_prefix   => '[Staging] ',
    :delivery_method  => :smtp,
    :delivery_settings => {
      :address        => 'smtp.sendgrid.net',
      :port           => '25',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => ENV['SENDGRID_DOMAIN']
    }
  }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright
Copyright © 2012 Garrett Bjerkhoel. See [MIT-LICENSE](https://github.com/dewski/mail_gate/blob/master/LICENSE) for details.
