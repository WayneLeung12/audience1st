class CreateAccountCodes < ActiveRecord::Migration
  def self.up
    rename_table 'donation_funds', 'account_codes'
    rename_column 'account_codes', 'account_code', 'code'
    change_column 'account_codes', 'code', :string, :null => true, :default => nil

    default_ac_id = AccountCode.default_account_code_id

    rename_column 'donations', 'donation_fund_id', 'account_code_id'
    add_column('vouchertypes', 'account_code_id', :integer,
      :null => false, :default => default_ac_id)

    codes = 
      Vouchertype.find_by_sql(
      'select distinct account_code from vouchertypes
        where account_code is not null and account_code != ""').
      map { |v| v.attributes['account_code'] } +
      Donation.find_by_sql(
      'select distinct account_code from donations
        where account_code is not null and account_code != ""').
      map { |v| v.attributes['account_code'] }
      
    codes.each do |code|
      ac = AccountCode.find_by_code(code)
      if ac.nil?
        puts "Creating account code for '#{code}'"
        ac = AccountCode.create!(:code => code, :name => "Account code #{code}")
      else
        puts "Using account code #{ac.id} for '#{code}'"
      end
      Vouchertype.update_all("account_code_id = #{ac.id}", "account_code = '#{code}'")
      Donation.update_all("account_code_id = #{ac.id}", "account_code = '#{code}'")
    end
    Vouchertype.update_all("account_code_id = #{default_ac_id}","account_code IS NULL or account_code=''")
    Donation.update_all("account_code_id = #{default_ac_id}","account_code IS NULL or account_code=''")
    remove_column 'vouchertypes', 'account_code'
    remove_column 'donations', 'account_code'
  end

  def self.down
    add_column 'vouchertypes', 'account_code', :string
    add_column 'donations', 'account_code', :string
    AccountCode.find(:all).each do |ac|
      Vouchertype.update_all("account_code='#{ac.code}'", "account_code_id = #{ac.id}")
      Donation.update_all("account_code='#{ac.code}'", "account_code_id = #{ac.id}")
    end
    remove_column :vouchertypes, :account_code_id
    rename_column 'donations', 'account_code_id', 'donation_fund_id'
    rename_table 'account_codes', 'donation_funds'
    rename_column 'donation_funds', 'code', 'account_code'
  end
end
