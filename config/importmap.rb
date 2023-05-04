# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "channels/consumer", preload: true
pin "channels/project_channel", preload: true
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.0.4/app/assets/javascripts/actioncable.esm.js"
