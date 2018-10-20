#!/usr/bin/env ruby


require "mysql2"
require "json"

# validate json
require "rubygems"

LOCAL=true

class FindVets
   DB_CONFIG_FILE = Rails.root + "app/api/queries/dbinfo.dat"


   def initialize()

      @client = init_db DB_CONFIG_FILE


      @user_fields =  [ "id",
                        "email",
                        "username",
                        "remember_created_at",
                        "sign_in_count",
                        "current_sign_in_at",
                        "last_sign_in_at",
                        "current_sign_in_ip",
                        "last_sign_in_ip",
                        "created_at",
                        "updated_at",
                        "role",
                        "admin",
                        "gps_location",
                        "location",
                        "address",
                        "city",
                        "state",
                        "zip",
                        "phone",
                        "first_name",
                        "last_name",
                        "website",
                        "is_minor",
                        "parent_email",
                        "profile_image",
                        "business_name",
                        "bio",
                        "background_image"
      ]


   end

   def init_db(config_file)
      db_host = ""
      db_name = ""
      db_username = ""
      db_password = ""

      if File.file?(config_file)
         IO.readlines(config_file).each do |line|
            key, val = line.split('=')

            case key
            when "DB_HOST"
               db_host = val.strip
            when "DB_NAME"
               db_name = val.strip
            when "DB_USERNAME"
               db_username = val.strip
            when "DB_PASSWORD"
               db_password = val.strip
            end
         end
      else
         puts("File '#{config_file}' does not exist!")
      end

      client = Mysql2::Client.new(:host => db_host, :username => db_username, :password => db_password)
      client.select_db(db_name)
      return client

   end

   def get_sql_fields_in_string (table_name, fields)
      user_fields=""
      is_first = true

      table = table_name
      fields_arr = fields

      for f in fields_arr
         if is_first
            user_fields = "`#{table}`.#{f}"
            is_first = false
         else
            #user_fields = "#{user_fields}, `users`.#{f}"
            user_fields = "#{user_fields}, `#{table}`.#{f}"
         end
      end
      #return "`#{@main_table}`.*, #{user_fields}"
      return user_fields
   end

   def search_table_by_SQL_LIKE_EXPRESSION (search_string, select_fields, from_table_name, where_table_name, field_name)
      sql_qry = "SELECT #{select_fields} FROM #{from_table_name} " +
          "WHERE #{where_table_name}.#{field_name} LIKE \"#{search_string}%\""

      #puts(sql_qry)
      return @client.query(sql_qry, :as => JSON)
   end


   def get_vet_by_first_name (search_string)
      from_table_name = "users"
      where_table_name = from_table_name
      field = "first_name"
      select_fields_string = get_sql_fields_in_string from_table_name, @user_fields

      #return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, table_name, field_name
      return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, from_table_name, where_table_name, field
   end

   def get_vet_by_last_name (search_string)
      from_table_name = "users"
      where_table_name = from_table_name
      field = "last_name"
      select_fields_string = get_sql_fields_in_string from_table_name, @user_fields

      #return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, table_name, field_name
      return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, from_table_name, where_table_name, field
   end

   def get_vet_by_username (search_string)
      from_table_name = "users"
      where_table_name = from_table_name
      field = "username"
      select_fields_string = get_sql_fields_in_string from_table_name, @user_fields

      #return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, table_name, field_name
      return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, from_table_name, where_table_name, field
   end

   def get_vet_by_search_string (search_string)
      results = get_vet_by_first_name search_string
      if results.count > 0
         return results

      end
      results = get_vet_by_last_name search_string
      if results.count > 0
         return results
      end
      results = get_vet_by_username search_string
      if results.count > 0
         return results
      end
      results = get_vet_by_businessname search_string
      if results.count > 0
         return results
      end

      return "{}"
   end

   def get_vet_by_businessname (search_string)
      from_table_name = "`businesses` INNER JOIN `users` ON `businesses`.user_id = `users`.id"
      where_table_name = "businesses"
      select_fields_table = "users"
      field = "name"
      select_fields_string = get_sql_fields_in_string select_fields_table, @user_fields

      return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, from_table_name, where_table_name, field
   end

   def results_to_json(results)
      json_results = "["
      results.each do |convo|
         json_results = json_results + JSON.pretty_generate(convo) + ", "
         #puts(JSON.pretty_generate(convo))
      end
      json_results = json_results.chop().chop()
      if json_results == ""
         return "{}"
      end
      return json_results + "]"
   end

   def json_valid?(str)
      JSON.parse(str)
      puts(str)
      return true
   rescue JSON::ParserError => e
      puts(str)
      puts(e.message)
      return false
   end

end

#vets = FindVets.new
#results_by_search_string = vets.get_vet_by_search_string "Vet"
#if results_by_search_string == "{}"
#   json_results = "{}"
#else
#   json_results = vets.results_to_json results_by_search_string
#end

#if vets.json_valid?(json_results)
#   puts("Valid json!!!")
#else
#   puts("Invalid!!!")
#end

