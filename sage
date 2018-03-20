
[1mFrom:[0m /home/blonde_q/work/lemon_squeezer/lib/lemon_squeezer/request.rb @ line 6 LemonSqueezer::Request#initialize:

     [1;34m5[0m: [32mdef[0m [1;34minitialize[0m(mandatory_params, params, message, config_name, public_ip, url, root, result = [1;36mnil[0m)
 =>  [1;34m6[0m:   binding.pry
     [1;34m7[0m:   @mandatory_params = mandatory_params
     [1;34m8[0m:   @params           = params
     [1;34m9[0m:   @config_name      = config_name
    [1;34m10[0m:   @message          = message.merge([1;34;4mLemonSqueezer[0m.configuration.auth(config_name, public_ip))
    [1;34m11[0m:   @url              = url.to_sym
    [1;34m12[0m:   @root             = root
    [1;34m13[0m:   @result           = [32mif[0m result
    [1;34m14[0m:                         result.to_sym
    [1;34m15[0m:                       [32melse[0m
    [1;34m16[0m:                         url.to_sym
    [1;34m17[0m:                       [32mend[0m
    [1;34m18[0m: [32mend[0m

