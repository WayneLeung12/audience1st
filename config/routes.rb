ActionController::Routing::Routes.draw do |map|
  map.resources :bulk_downloads
  map.resources :account_codes
  map.resources :imports
  map.connect '/imports/download_invalid/:id', :controller => 'imports', :action => 'download_invalid'
  map.connect '/imports/help', :controller => 'imports', :action => 'help'
  map.resources :labels
  

  # admin-only actions
  map.temporarily_disable_admin '/disable_admin', :controller => 'customers', :action => 'temporarily_disable_admin'
  map.reenable_admin '/reenable_admin',  :controller => 'customers', :action => 'reenable_admin'

  # begin new RESTful customer routes
  map.connect '/customers/auto_complete_for_customer_full_name', :controller => 'customers', :action => 'auto_complete_for_customer_full_name'
  map.list_customers '/customers/list', :controller => 'customers', :action => 'list'
  map.list_duplicates '/customers/list_duplicates', :controller => 'customers', :action => 'list_duplicates'
  
  map.merge_customers '/customers/merge', :controller => 'customers', :action => 'merge', :conditions => {:method => :get}
  map.finalize_merge '/customers/finalize_merge', :controller => 'customers', :action => 'finalize_merge', :conditions => {:method => :post}
  map.search_customers  '/customers/search', :controller => 'customers', :action => 'search', :conditions => {:method => :get}
  map.lookup_customer  '/customers/lookup', :controller => 'customers', :action => 'lookup'
  map.forgot_password '/customers/forgot_password', :controller => 'customers', :action => 'forgot_password'
  map.new_customer '/customers/new', :controller => 'customers', :action => 'new', :conditions => {:method => :get}

  map.customer '/customers/:id', :controller => 'customers', :action => 'welcome', :conditions => {:method => :get}
  map.edit_customer '/customers/:id/edit', :controller => 'customers', :action => 'edit', :conditions => {:method => :get}
  map.change_password '/customers/:id/change_password', :controller => 'customers', :action => 'change_password'
  map.change_secret_question '/customers/:id/change_secret_question', :controller => 'customers', :action => 'change_secret_question'
  map.update_customer '/customers/:id/update', :controller => 'customers', :action => 'update', :conditions => {:method => :post}

  map.create_customer '/customers/create', :controller => 'customers', :action => 'create', :conditions => {:method => :post}
  map.user_create_customer '/customers/user_create', :controller => 'customers', :action => 'user_create', :conditions => {:method => :post}
  # begin new RESTful customer routes


  # RSS

  map.connect '/info/ticket_rss', :controller => 'info', :action => 'ticket_rss', :conditions => {:method => :get}
  

  # shows
  map.resources :shows, :except => [:show]
  map.resources :showdates, :except => [:index]
  map.resources :valid_vouchers, :except => [:index]
  map.resources :vouchertypes
  map.connect '/vouchertypes/clone/:id', :controller => 'vouchertypes', :action => 'clone', :conditions => {:method => :get}

  # vouchers
  map.connect '/vouchers/update_shows', :controller => 'vouchers', :action => 'update_shows'
  map.customer_add_voucher '/customer/:id/addvoucher', :controller => 'vouchers', :action => 'addvoucher', :conditions => {:method => :get}
  map.customer_process_add_voucher '/customer/:id/process_addvoucher', :controller => 'vouchers', :action => 'process_addvoucher', :conditions => {:method => :post}
  
  # with :id
  map.connect '/vouchers/reserve/:id', :controller => 'vouchers', :action => 'reserve', :conditions => {:method => :get}
  %w(update_comment confirm_multiple confirm_reservation cancel_prepaid cancel_multiple cancel_reservation).each do |action|
    map.connect "/vouchers/#{action}", :controller => 'vouchers', :action => action, :conditions => {:method => :post}
  end

  # database txns
  map.connect '/txns', :controller => 'txn', :action => 'index', :conditions => {:method => :get}

  # customer visits
  map.resources 'visits'
  map.customer_visits '/customer/:id/visits', :controller => 'visits', :action => 'index'
  map.connect '/visits/list_by_prospector', :controller => 'visits', :action => 'list_by_prospector', :conditions => {:method => :get}

  # reports
  map.reports '/reports', :controller => 'reports', :action => 'index'
  %w(do_report run_special_report advance_sales transaction_details_report accounting_report retail show_special_report unfulfilled_orders).each do |report_name|
    map.connect "/reports/#{report_name}", :controller => 'reports', :action => report_name
  end
  # reports that consume :id
  %w(showdate_sales subscriber_details).each do |report_name|
    map.connect "/reports/#{report_name}/:id", :controller => 'reports', :action => report_name
  end
  # update actions
  %w(mark_fulfilled create_sublist).each do |action|
    map.connect "/reports/#{action}", :controller => 'reports', :action => action, :conditions => {:method => :post}
  end

  # customer-facing purchase pages
  # :promo_code is an optional route argument; in Rails 3, would be in parens #rails3

  map.store     '/store/:promo_code', :controller => 'store', :action => 'index', :promo_code => nil, :conditions => {:method => :get}
  map.store_special   '/special/:promo_code', :controller => 'store', :action => 'index', :what => 'special', :promo_code => nil, :conditions => {:method => :get}
  map.store_subscribe '/subscribe/:promo_code', :controller => 'store', :action => 'subscribe', :promo_code => nil, :conditions => {:method => :get}
  %w(shipping_address checkout edit_billing_address show_changed showdate_changed).each do |action|
    map.send(action, "/#{action}", :controller => 'store', :action => action)
  end

  %w(process_cart set_shipping_address place_order).each do |action|
    map.send(action, "/#{action}", :controller => 'store', :action => action, :conditions => {:method => :post})
  end
  
  map.donate_to_fund '/store/donate_to_fund/:id', :controller => 'store', :action => 'donate_to_fund', :conditions => {:method => :get}
  map.quick_donate '/donate', :controller => 'store', :action => 'donate', :conditions => {:method => :get}
  map.process_quick_donation '/process_quick_donation', :controller => 'store', :action => 'process_quick_donation', :conditions => {:method => :post}

  # donations management

  map.donations '/donations', :controller => 'donations', :action => 'index', :conditions => {:method => :get}
  map.connect '/donations/mark_ltr_sent',  :controller => 'donations', :action => 'mark_ltr_sent', :conditions => {:method => :get}
  
  # config options

  map.options '/options', :controller => 'options', :action => 'edit', :conditions => {:method => :get}
  map.connect '/options/update', :controller => 'options', :action => 'update', :conditions => {:method => :put}

  # walkup sales

  map.walkup_sales '/box_office/walkup/:id', :controller => 'box_office', :action => 'walkup', :conditions => {:method => :get}
  map.walkup_default '/box_office/walkup', :controller => 'box_office', :action => 'walkup', :conditions => {:method => :get}
  map.connect "/box_office/change_showdate", :controller => 'box_office', :action => 'change_showdate'
  map.door_list '/box_office/:id/door_list', :controller => 'box_office', :action => 'door_list', :conditions => {:method => :get}
  map.checkin  '/box_office/:id/checkin', :controller => 'box_office', :action => 'checkin', :conditions => {:method => :get}
  map.walkup_report '/box_office/:id/walkup_report', :controller => 'box_office', :action => 'walkup_report', :conditions => {:method => :get}
  %w(do_walkup_sale modify_walkup_vouchers).each do |action|
    map.connect "/box_office/#{action}", :controller => 'box_office', :action => action, :conditions => {:method => :post}
  end
  map.connect '/box_office/mark_checked_in', :controller => 'box_office', :action => 'mark_checked_in', :conditions => {:method => :post}


  # special shortcuts
  map.login '/login', :controller => 'sessions', :action => 'new', :conditions => {:method => :get}
  # legacy login route
  map.connect '/customers/login', :controller => 'sessions', :action => 'new', :conditions => {:method => :get}
  map.secret_question '/login_with_secret', :controller => 'sessions', :action => 'new_from_secret_question',:conditions => {:method => :get}
  map.connect '/sessions/create_from_secret_question', :controller => 'sessions', :action => 'create_from_secret_question', :conditions => {:method => :post}
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.change_user '/not_me', :controller => 'sessions', :action => 'not_me'

  map.resource :session # other session actions

  map.connect 'subscribe', :controller => 'store', :action => 'subscribe', :conditions => {:method => :get}

  # Routes for viewing and refunding orders
  map.order '/orders/:id', :controller => 'orders', :action => 'show', :conditions => {:method => :get}
  map.connect '/orders/refund/:id', :controller => 'orders', :action => 'refund', :conditions => {:method => :post}
  map.customer_orders '/orders/by_customer/:id', :controller => 'orders', :action => 'by_customer'

  map.root :controller => 'customers', :action => 'home'
 
end
