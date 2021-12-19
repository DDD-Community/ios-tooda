class BaseApp
  @plist_path = ""

  def self.plist_path
    @plist_path
  end
end



module AppInfo

  class ReleaseApp < BaseApp
    @plist_path = "./Tooda/Sources/SupportFiles/Info.plist"
  end
end
