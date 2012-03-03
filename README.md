MailGate [![Build Status](https://secure.travis-ci.org/dewski/mail_gate.png)](http://travis-ci.org/dewski/mail_gate)
========

MailGate is an additional delivery method for the [Mail](https://github.com/mikel/mail) gem that lets you restrict the delivery of mail to only whitelisted emails. Ideal for staging environments where you may be using production data and do not want them to recieve emails from your mailers when you submit comments, contact forms, or anything else that may trigger mail delivery.

## Installation

Add this line to your application's Gemfile:

    gem 'mail_gate'

And then run:

    $ bundle

Or install it yourself as:

    $ gem install mail_gate

## Usage

MailGate works as a standalone extension to the [Mail](https://github.com/mikel/mail) gem or as a delivery method within Rails applications.

To configure MailGate, edit your ActionMailer configuration to use `:mail_gate` as the delivery method, then copy your existing settings to  `mail_gate_settings`:

```ruby
# config/environments/staging.rb
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

Becomes:

```ruby
# config/environments/staging.rb
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

Email now sent within the staging environment will extract any recipient emails that don't match the whitelist. If after being filtered there aren't any recipients left because they were filtered out, no email will be sent:

```
> Article.first.comments.each do |comment|
>   "Email for: #{comment.user.email}"
>   ArticleMailer.new_comment(article, comment).deliver
> end
=> Email for: john.doe@gmail.com
=> Email for: megatron@transformers.com
=> Email for: george@cnn.com
=> #<Mail::Message:70236177475420, Headers: <From: no-reply@cnn.com>, <To: george@cnn.com>, <Subject: [Staging] New comment on your article!>>
```

Notice only the email for `george@cnn.com` was delivered.

## Using MailGate outside of Rails

If you have a Sinatra app or just using the Mail library in your Ruby project you can still use MailGate:

```ruby
require 'mail_gate'

Mail.defaults do
  delivery_method MailGate::Filter,
    :whitelist => /cnn.com/,
    :subject_prefix => '[local] ',
    :delivery_method => :file,
    :location => '/dev/null'
end
```

Then just deliver the email as normal:

```ruby
Mail.deliver do
  to 'george@cnn.com'
  from 'no-reply@cnn.com'
  subject 'Testing MailGate'
  body 'Hi! :)'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright
Copyright © 2012 Garrett Bjerkhoel. See [LICENSE](https://github.com/dewski/mail_gate/blob/master/LICENSE) for details.
