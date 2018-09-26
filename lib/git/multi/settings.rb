module Git
  module Multi
    module Settings

      TICK  = ['2714'.hex].pack('U*').green.freeze
      CROSS = ['2718'.hex].pack('U*').red.freeze
      ARROW = ['2794'.hex].pack('U*').blue.freeze

      module_function

      def setting_status(messages, valid, optional = false)
        fields = messages.compact.join(' - ')
        icon = valid ? TICK : optional ? ARROW : CROSS
        if interactive?
          print "   #{fields}"
          sleep 0.66
          puts "\x0d#{icon}"
        else
          puts "#{icon}  #{fields}"
        end
      end

      def file_status(file, message = 'File')
        setting_status(
          [
            message,
            abbreviate(file),
            File.file?(file) ? "#{File.size(file).commify} bytes" : nil,
          ],
          file && !file.empty? && File.file?(file),
          false
        )
      end

      def directory_status(messages, directory)
        setting_status(
          messages,
          directory && !directory.empty? && File.directory?(directory),
          false
        )
      end

      def workarea_status(message, workarea, owner)
        directory_status(
          [
            message,
            File.join(abbreviate(workarea, :workarea), owner),
            File.directory?(workarea) ? "#{Dir.new(workarea).git_repos(owner).count.commify} repos" : nil
          ],
          workarea
        )
      end

      def user_status(user)
        setting_status(['User', user], user && !user.empty?)
      end

      def organization_status(orgs)
        orgs.each do |org|
          setting_status(['Organization', org], org && !org.empty?, true)
          setting_status(['Organization', 'member?'], Git::Hub.orgs.include?(org), !Git::Hub.connected?)
        end
      end

      def token_status(token)
        setting_status(['Token', symbolize(token), describe(token)], !token.nil? && !token.empty?)
        setting_status(['Token', 'valid?'], !token.nil? && !token.empty? && Git::Hub.login, !Git::Hub.connected?)
        setting_status(['Token', "owned by #{Git::Multi::USER}?"], Git::Hub.login == Git::Multi::USER, !Git::Hub.connected?)
      end

      def home_status(home)
        directory_status(['Home', home], home)
      end

      def main_workarea_status(workarea)
        directory_status(['Workarea (main)', abbreviate(workarea, :home)], workarea)
      end

      def user_workarea_status(users)
        users.each do |user|
          workarea_status("Workarea (user: #{user})", Git::Multi::WORKAREA, user)
        end
      end

      def organization_workarea_status(orgs)
        orgs.each do |org|
          workarea_status("Workarea (org: #{org})", Git::Multi::WORKAREA, org)
        end
      end

    end
  end
end
