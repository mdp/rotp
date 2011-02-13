# ROTP - The Ruby One Time Password Library

## Dependencies

* OpenSSL
* Base32

## Installation

    gem install rotp

## Use

### Time based OTP's

    totp = ROTP::TOTP.new("base32secret3232")
    totp.now # => 492039
    totp.at(Time.now.to_i + 30) # => 102922

### Counter based OTP's

    hotp = ROTP::HOTP.new("base32secretkey3232")
    hotp.at(0) # => 260182
    hotp.at(1) # => 55283
    hotp.at(1401) # => 316439


### Generating a Base32 Secret key

    ROTP.random_base32 # returns a 16 character base32 secret. Compatible with Google Authenticator

### Google Authenticator Interop

The library works with the Google Authenticator iPhone and Android app, and also
includes the ability to generate provisioning URI's for use with the QR Code scanner
built into the app.

    hotp.provisioning_uri # => 'otpauth://totp/alice@google.com?secret=JBSWY3DPEHPK3PXP'

This can then be rendered as a QR Code which can then be scanned and added to the users
list of OTP credentials.
