module LemonSqueezer
  class Utils
    def self.mandatory_params_present?(mandatory_params, params)
      mandatory_params.map {|p| params.has_key?(p)}.all?
    end
  end
end
