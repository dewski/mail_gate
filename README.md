MailGate [![Build Status](https://secure.travis-ci.org/dewski/mail_gate.png)](http://travis-ci.org/dewski/mail_gate)
========

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

Now just change your `delivery_method` to use `:mail_gate` then move your settings to `:delivery_settings` like shown below.

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

Email now sent within the staging environment will extract any emails that don't match the whitelist. If after being filtered there are no more recipients because they were filtered out, no email will be sent:

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
Copyright © 2012 Garrett Bjerkhoel. See [MIT-LICENSE](https://github.com/dewski/mail_gate/blob/master/LICENSE) for details.
