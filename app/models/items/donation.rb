# to do:
#  add logic to init new donation with correct default account_code (from options)

class Donation < Item

  def self.default_code
    AccountCode.find(Option.default_donation_account_code)
  end
  
  belongs_to :account_code
  validates_associated :account_code
  validates_presence_of :account_code_id
  
  belongs_to :customer
  
  validates_numericality_of :amount
  validates_inclusion_of :amount, :in => 1..10_000_000, :message => "must be at least 1 dollar"

  def self.from_amount_and_account_code_id(amount, id, comments = nil)
    if id.blank? || (use_code = AccountCode.find_by_id(id)).nil?
      use_code = Donation.default_code
    end
    Donation.new(:amount => amount.to_f, :account_code => use_code, :comments => comments)
  end

  def price ; self.amount ; end # why can't I use alias for this?

  def item_description
    "Donation: #{account_code.name_or_code}"
  end

  def one_line_description
    sprintf("$%6.2f  Donation to #{account_code.name}", amount)
  end

  def description_for_audit_txn
    sprintf("%.2f #{account_code.name} donation [#{id}]", amount)
  end

  def self.walkup_donation(amount)
    Donation.new(:amount => amount, :account_code => Donation.default_code)
  end
end
