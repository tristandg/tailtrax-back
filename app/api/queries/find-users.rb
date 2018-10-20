#!/usr/bin/env ruby


require "mysql2"
require "json"

# validate json
require "rubygems"

#private def init_db(config_file)
#private def role_str_to_num (role_str)
#private def get_sql_fields_in_string (table_name, fields)
#private def search_table_by_SQL_LIKE_EXPRESSION (search_string, select_fields, from_table_name, where_table_name, field, role_str)
#private def get_user_by_businessname (search_string, role_str)
#def find_users_by_role (search_string, role_str)
#def get_all_users_belonging_to_role (role_str)
#def get_all_users ()
#def get_users_belonging_to_role_that_i_followed (role_str, follower_user_id)
#def get_user_by_search_string (search_string, role_str)
#def results_to_json(results)
#def json_valid?(str)

class FindUsers

   UNDEFINED_ROLE = -1
   LOCAL = false
   if LOCAL
      DB_CONFIG_FILE = "dbinfo.dat"
   else
      DB_CONFIG_FILE = Rails.root + "app/api/queries/dbinfo.dat"
   end
 

   def initialize()
      #@logger.log.info "Init NewConversations()!!!"

      #@HOST="18.222.121.128"
      #@DB_NAME="TailTraxAPI_development"

      @client = init_db DB_CONFIG_FILE

      # roles to numbers in DB
      #"user": 0
      #"pet_parent": 1
      #"litter_administrator": 2
      #"vet": 3
      #"admin": 4
      #"super_admin": 5
      @roles =  {
          :user => 0,
          :pet_parent => 1,
          "litter_administrator" => 2,
          "vet" => 3,
          "admin" => 4,
          "super_admin" => 5
               }


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

   private def init_db(config_file)
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

   # database stores role as an integer, and this is the mapping
   # TODO: handle inputs of multiple roles
   private def role_str_to_num (role_str)
      return @roles[role_str] || UNDEFINED_ROLE
   end

   private def get_sql_fields_in_string (table_name, fields)
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

   private def search_table_by_SQL_LIKE_EXPRESSION (search_string, select_fields, from_table_name, where_table_name, field, role_str)
      sql_qry = "SELECT #{select_fields} FROM #{from_table_name} " +
                "WHERE #{where_table_name}.#{field} LIKE \"%#{search_string}%\" AND #{from_table_name}.role in (#{role_str_to_num(role_str)})"

      #puts(sql_qry)
      return @client.query(sql_qry, :as => JSON)
   end

   private def get_user_by_businessname (search_string, role_str)
      from_table_name = "`businesses` INNER JOIN `users` ON `businesses`.user_id = `users`.id"
      where_table_name = "businesses"
      select_fields_table = "users"
      field = "name"
      select_fields_string = get_sql_fields_in_string select_fields_table, @user_fields

      sql_qry = "SELECT #{select_fields_string} FROM #{from_table_name} " +
                "WHERE #{where_table_name}.#{field} LIKE \"%#{search_string}%\" AND #{select_fields_table}.role in (#{role_str_to_num(role_str)})"

      #puts(sql_qry)
      return @client.query(sql_qry, :as => JSON)
      #return search_table_by_SQL_LIKE_EXPRESSION search_string, select_fields_string, from_table_name, where_table_name, field, role_str
   end

   private def find_users_by_role (search_string, role_str)
      from_table_name = "users"
      where_table_name = from_table_name
      field1 = "first_name"
      field2 = "last_name"
      field3 = "username"
      select_fields_string = get_sql_fields_in_string from_table_name, @user_fields

      #puts(role_str)

      sql_qry = "SELECT #{select_fields_string} FROM #{from_table_name} " +
                "WHERE #{where_table_name}.#{field1} LIKE \"#{search_string}%\" AND #{from_table_name}.role in (#{role_str_to_num(role_str)}) " +
                "OR #{where_table_name}.#{field2} LIKE \"#{search_string}%\" AND #{from_table_name}.role in (#{role_str_to_num(role_str)}) " +
                "OR #{where_table_name}.#{field3} LIKE \"#{search_string}%\" AND #{from_table_name}.role in (#{role_str_to_num(role_str)}) "

      #puts(sql_qry)
      return @client.query(sql_qry, :as => JSON)
   end

   def get_all_users_belonging_to_role (role_str)
      from_table_name = "users"
      where_table_name = from_table_name

      field1 = "first_name"
      field2 = "last_name"
      field3 = "username"
      select_fields_string = get_sql_fields_in_string from_table_name, @user_fields

      #puts(role_str)

      sql_qry = "SELECT #{select_fields_string} FROM `users` "
                "WHERE `users`.role in (#{role_str_to_num(role_str)})" 

      #puts(sql_qry)
      return @client.query(sql_qry, :as => JSON)
   end

   def get_all_users ()
      select_fields_string = get_sql_fields_in_string "users", @user_fields

      sql_qry = "SELECT #{select_fields_string} FROM `users` "

      return @client.query(sql_qry, :as => JSON)
   end

   def get_users_belonging_to_role_that_i_followed (role_str, follower_user_id)
      from_table_name = "users"
      where_table_name = from_table_name

      field1 = "first_name"
      field2 = "last_name"
      field3 = "username"
      select_fields_string = get_sql_fields_in_string from_table_name, @user_fields

      #puts(role_str)

      sql_qry = "SELECT #{select_fields_string} FROM `follows` INNER JOIN `users` ON `follows`.follow_id = `users`.id " +
                "WHERE `users`.role in (#{role_str_to_num(role_str)}) AND `follows`.user_id = #{follower_user_id}" 

      #puts(sql_qry)
      return @client.query(sql_qry, :as => JSON)
   end

   def get_user_by_search_string (search_string, role_str)
      results = find_users_by_role search_string, role_str
      if results.count > 0
         return results
      end

      results = get_user_by_businessname search_string, role_str
      if results.count > 0
         return results
      end

      return "{}"
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

users = FindUsers.new
#results_by_search_string = users.get_user_by_search_string "art", "pet_parent"
#results_by_search_string = users.get_user_by_search_string "cockap", "vet"
#results_by_search_string = users.get_users_belonging_to_role_that_i_followed "litter_administrator", 24
#results_by_search_string = users.get_all_users_belonging_to_role ("pet_parent")
#results_by_search_string = users.get_all_users 
results_by_search_string = users.find_users_by_role "art", "pet_parent"
#def find_users_by_role (search_string, role_str)
#def get_user_by_search_string (search_string, role_str)

if results_by_search_string == "{}"
   json_results = "{}"
else
   json_results = users.results_to_json results_by_search_string
end

if not users.json_valid?(json_results)
  puts("Invalid json!!!")
end

