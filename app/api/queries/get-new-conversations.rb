#!/usr/bin/env ruby


require "mysql2"
require "json"

class NewConversations
   def initialize()
      @HOST="18.222.121.128"
      @DB_NAME="TailTraxAPI_development"


      @client = Mysql2::Client.new(:host => @HOST, :username => "root", :password => "dhT3tfN$p9w9")
      @client.select_db(@DB_NAME)

      @id=7
      @conversation_id=4

      @main_table = "direct_messages"
      @embed_table = "users"
      @embed_table_fields =  [ "id",
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

   def embed_table_in_results(results)
      table_name = @embed_table
      table_fields = @embed_table_fields 
      
      new_table = Array.new
      results.each do |row|
         users = {}
      
         table_fields.each do |f|
      #      new_hash = { "#{f}" => "#{row[f]}" }
      #      users.merge!( new_hash )
            users.merge!( { f => row[f] } )
            #puts("'" + f + "' -> #{row[f]}")
            row.delete(f)
            #puts(row[f])
         end
      
         row.merge! ( { table_name => users } )
         #puts JSON.pretty_generate(row)
         new_table.push(row)
         #puts JSON.pretty_generate(users)
      #   puts JSON.pretty_generate(users)
      end
      return new_table
   end
   
   def print_conversations (new_conversations)
      new_conversations.each do |convo|
         puts JSON.pretty_generate(convo)
      end
   end
   
   def get_sql_fields_in_string ()
      user_fields=""
      is_first = true

      table = @embed_table
      fields_arr = @embed_table_fields
   
      for f in fields_arr
         if is_first
            user_fields = "`#{table}`.#{f}"
            is_first = false
         else
            #user_fields = "#{user_fields}, `users`.#{f}"
            user_fields = "#{user_fields}, `#{table}`.#{f}"
         end
      end
      return "`#{@main_table}`.*, #{user_fields}"
   end

   def get_new_conversations(conversation_id, last_direct_message_id)
      @conversation_id = conversation_id
      @id = last_direct_message_id

      fields = get_sql_fields_in_string 
      sql_qry = "SELECT #{fields} FROM `direct_messages` INNER JOIN `users` ON `direct_messages`.user_id = `users`.id " +
          "WHERE `direct_messages`.conversation_id = #{@conversation_id} AND `direct_messages`.id > #{@id}"

      return @client.query(sql_qry, :as => JSON)
   end

   # returns user table (embed_table) as embedded hash of direct_messages (main_table) results
   def reformat_query_results(results)
      return embed_table_in_results results
   end

   def results_to_json(results)
      json_results = "["
      results.each do |convo|
         json_results = json_results + JSON.pretty_generate(convo) + ", "
      end
      puts(json_results.chop())
      return json_results + "]"
   end

end

#new_convos = NewConversations.new()

#results = new_convos.get_new_conversations 4,7
#new_conversations = new_convos.reformat_query_results results

#s = new_convos.results_to_json results
##new_convos.print_conversations new_conversations
#puts(s)


