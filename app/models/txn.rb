class Txn < ActiveRecord::Base
  belongs_to :purchasemethod
  belongs_to :show
  belongs_to :showdate
  belongs_to :customer

  Txn::TYPES = {
    "other" => "Other",
    "tkt_purch" => "Ticket purchase",
    "sub_purch" => "Subscription purchase",
    "add_tkts" => "Add tickets to account",
    "oth_purch" => "Other purchase",
    "edit" => "Edit customer info",
    "don_cash" => "Donation - Cash",
    "don_svc" => "Donation - Services",
    "don_good" => "Donation - Goods or In-Kind",
    "res_made" => "Reservation",
    "res_cancl" => "Cancellation",
    "pmt_rcv" => "Receipt of Pending Payment",
    "refund" => "Refund",
    "del_tkts" => "Remove tickets from account",
    "???" => "UNKNOWN",
    "config" => "Configuration Change",
    "don_ack" => "Acknowledge donation"
  }

  def desc ; TYPES[type.to_s][1] rescue "???" ; end

  # provide a handler to be called when customers are merged.
  # Transfers the txns from old to new id, and also changes the
  # values of entered_by_id field, which is really a customer id.
  # Returns number of actual txns transferred.

  def self.foreign_keys_to_customer
    [:entered_by_id, :customer_id]
  end

  # since the audit record schema is generic, not all fields are
  # relevant for every entry. 

  def self.add_audit_record(args={})

    cust_id = args[:customer_id] || Customer.nobody_id
    logged_in = args[:logged_in_id].to_i
    show_id =  args[:show_id].to_i
    showdate_id = args[:showdate_id].to_i
    voucher_id =  args[:voucher_id].to_i
    amt = args[:dollar_amount].to_f
    comments =  args[:comments] ||  ''
    purch_id = args[:purchasemethod_id] || Purchasemethod.get_type_by_name('none')

    order_id = args[:order_id].to_i
    a = Txn.create( :customer_id => cust_id,
                     :entered_by_id => logged_in,
                     :txn_date => Time.now,
                     :txn_type => args[:txn_type] || '???',
                     :show_id => show_id,
                     :showdate_id => showdate_id,
                     :purchasemethod_id => purch_id,
                     :voucher_id => voucher_id,
                     :order_id => order_id,
                     :dollar_amount => amt,
                     :comments => comments  )
    a.id
  end
end

