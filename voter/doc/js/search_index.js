var search_data = {"index":{"searchIndex":["applicationcable","channel","connection","applicationcontroller","applicationjob","applicationmailer","applicationrecord","counterclient","counterclienterror","datasigner","adminsignatureerror","datasignerresult","object","voter","application","votescontroller","activate_bundler()","activation_error_handling()","bundler_version()","cli_arg_version()","config()","env_var_version()","gemfile()","invoked_as_script?()","load_bundler!()","lockfile()","lockfile_version()","new()","new()","send_vote()","sign()","sign_vote()","system!()","to_h()","to_s()","unblind_message()","verify()","gemfile","gemfile.lock","readme","readme","rakefile","config.ru","credentials.yml.enc","development.log","robots","development_secret","restart"],"longSearchIndex":["applicationcable","applicationcable::channel","applicationcable::connection","applicationcontroller","applicationjob","applicationmailer","applicationrecord","counterclient","counterclient::counterclienterror","datasigner","datasigner::adminsignatureerror","datasignerresult","object","voter","voter::application","votescontroller","object#activate_bundler()","object#activation_error_handling()","object#bundler_version()","object#cli_arg_version()","voter#config()","object#env_var_version()","object#gemfile()","object#invoked_as_script?()","object#load_bundler!()","object#lockfile()","object#lockfile_version()","counterclient::new()","datasigner::new()","counterclient#send_vote()","votescontroller#sign()","datasigner#sign_vote()","object#system!()","datasignerresult#to_h()","datasignerresult#to_s()","datasigner#unblind_message()","datasigner#verify()","","","","","","","","","","",""],"info":[["ApplicationCable","","classes/ApplicationCable.html","",""],["ApplicationCable::Channel","","classes/ApplicationCable/Channel.html","",""],["ApplicationCable::Connection","","classes/ApplicationCable/Connection.html","",""],["ApplicationController","","classes/ApplicationController.html","",""],["ApplicationJob","","classes/ApplicationJob.html","",""],["ApplicationMailer","","classes/ApplicationMailer.html","",""],["ApplicationRecord","","classes/ApplicationRecord.html","",""],["CounterClient","","classes/CounterClient.html","","<p>This class represents a client that can make requests and receive response from the counter module\n"],["CounterClient::CounterClientError","","classes/CounterClient/CounterClientError.html","",""],["DataSigner","","classes/DataSigner.html","",""],["DataSigner::AdminSignatureError","","classes/DataSigner/AdminSignatureError.html","",""],["DataSignerResult","","classes/DataSignerResult.html","",""],["Object","","classes/Object.html","",""],["Voter","","classes/Voter.html","",""],["Voter::Application","","classes/Voter/Application.html","",""],["VotesController","","classes/VotesController.html","","<p>Votes controller is responsible for handling requests made to /votes Full API documentation can be found …\n"],["activate_bundler","Object","classes/Object.html#method-i-activate_bundler","(bundler_version)",""],["activation_error_handling","Object","classes/Object.html#method-i-activation_error_handling","()",""],["bundler_version","Object","classes/Object.html#method-i-bundler_version","()",""],["cli_arg_version","Object","classes/Object.html#method-i-cli_arg_version","()",""],["config","Voter","classes/Voter.html#method-i-config","()",""],["env_var_version","Object","classes/Object.html#method-i-env_var_version","()",""],["gemfile","Object","classes/Object.html#method-i-gemfile","()",""],["invoked_as_script?","Object","classes/Object.html#method-i-invoked_as_script-3F","()",""],["load_bundler!","Object","classes/Object.html#method-i-load_bundler-21","()",""],["lockfile","Object","classes/Object.html#method-i-lockfile","()",""],["lockfile_version","Object","classes/Object.html#method-i-lockfile_version","()",""],["new","CounterClient","classes/CounterClient.html#method-c-new","(client = RestClient, uri = Voter.config.counter_module_uri)","<p>Parameters:\n<p>client &mdash; Basically an object that is able to make post requests, RestClient by default\n<p>uri &mdash; string …\n"],["new","DataSigner","classes/DataSigner.html#method-c-new","(private_key: nil, encryptor: OnlineVoting::Crypto::Message, signer: OnlineVoting::Crypto::BlindSigner)","<p>Parameters:\n<p>private_key &mdash; Must be an RSA 512 bit length private key (string)\n<p>encryptor &mdash; object that can respond …\n"],["send_vote","CounterClient","classes/CounterClient.html#method-i-send_vote","(signed_message, bit_commitment)","<p>Parameters:\n<p>signed_message &mdash; Any kind of string, represents a bit commitment that was signed by administrator …\n"],["sign","VotesController","classes/VotesController.html#method-i-sign","()",""],["sign_vote","DataSigner","classes/DataSigner.html#method-i-sign_vote","(message, voter_id)","<p>Parameters:\n<p>message &mdash; must be a string. Becuase of current limitation a string of max 23 bytes\n<p>encryptor … &mdash; "],["system!","Object","classes/Object.html#method-i-system-21","(*args)",""],["to_h","DataSignerResult","classes/DataSignerResult.html#method-i-to_h","()",""],["to_s","DataSignerResult","classes/DataSignerResult.html#method-i-to_s","()",""],["unblind_message","DataSigner","classes/DataSigner.html#method-i-unblind_message","(signed_message, r, signing_key = admin_key)","<p>Parameters:\n<p>signed_message &mdash; message that was blinded and signed\n<p>r &mdash; blinding factor that was used to blind …\n"],["verify","DataSigner","classes/DataSigner.html#method-i-verify","(signed_message, message, signing_key = admin_key)","<p>Parameters:\n<p>signed_message &mdash; message that was blinded and signed\n<p>message &mdash; original message\n"],["Gemfile","","files/Gemfile.html","","<p>source &#39;rubygems.org&#39; git_source(:github) { |repo| “github.com/#{repo}.git” }\n<p>ruby &#39;2.6.5&#39; …\n"],["Gemfile.lock","","files/Gemfile_lock.html","","<p>GEM\n\n<pre><code>remote: https://rubygems.org/\nspecs:\n  actioncable (6.0.2.2)\n    actionpack (= 6.0.2.2)\n    nio4r ...\n</code></pre>\n"],["README","","files/README_md.html","","<p>README\n<p>Voter module is basically a helper for a voter.\n<p>So that he won&#39;t have to do all the complicated …\n"],["README","","files/README_rdoc.html","","<p>README\n<p>Voter module is basically a helper for a voter.\n<p>So that he won&#39;t have to do all the complicated …\n"],["Rakefile","","files/Rakefile.html","","<p># Add your own tasks in files placed in lib/tasks ending in .rake, # for example lib/tasks/capistrano.rake …\n"],["config.ru","","files/config_ru.html","","<p># This file is used by Rack-based servers to start the application.\n<p>require_relative &#39;config/environment&#39; …\n"],["credentials.yml.enc","","files/config/credentials_yml_enc.html","","<p>5S+ciH1LVq2nU88bujHI+kBPIIlrQSPOmqv8zAuI+oAARIsAAZ52luCSwn9Aw4FYW/sy9JmG9abla2+UpCUidc81IRdT4jm0y0EpOzh+ORQj+sFwk2nkvAQJiglw9bTrZ6f9njttazH2j5HmrvVzuUOlPtsYNgZSm3gKIhdw1cjwB2kv9EvEEWgOw9+HLO80yJDzZhkP/mvHiEDDrYV4kvZHmHLTK8t6jSmVJfxDe4NR+Wm/d09QOOOC6eKbCuE2YVIIIA44gz3P1puV9UhgjklMi5dDnyOoHl38shNB5rP17H8fJyIOtzWA9pUvynNiOhgNBpxYkg6kKSQp1kMuzNDt+sVcDC8Rq23nsVRcnIUELpzR0/WDQo2PnCScHz0N9FVM/a38ilz6ndmDbQpYoAactv8FZvcFbm1Q–SCel85LRUeUdtSur–Zdgj1T6xdFhtUu6l5oSkDw== …\n"],["development.log","","files/log/development_log.html","","<p>Started GET “/” for 127.0.0.1 at 2020-05-03 17:28:09 +0200\n<p>PG::ConnectionBad (could not connect …\n"],["robots","","files/public/robots_txt.html","","<p># See www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file\n"],["development_secret","","files/tmp/development_secret_txt.html","","<p>510a312ed1d62960b0fb7000f33c8d6ba71e0b827828698112088c5d511293595ac5c9bf6f2fd124f0c96ad752929e4c6a0af16af23c880a25cc8671b64cb373 …\n"],["restart","","files/tmp/restart_txt.html","",""]]}}