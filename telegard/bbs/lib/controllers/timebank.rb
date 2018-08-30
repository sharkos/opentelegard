=begin

===============================================================================
                 OpenTG (Telegard/2)  http://www.opentg.org                    
===============================================================================

See "LICENSE" file for distribution and copyright information. 
 
---[ File Info ]-------------------------------------------------------------

 Source File: /lib/controllers/timebank.rb
     Version: 0.01
   Author(s): Chris Tusa <chris.tusa@opentg.org>
 Description: Timebank controller.

-----------------------------------------------------------------------------
=end

=begin rdoc
= TimebankController
The Timebank controller manipulates the user's timebank balance. It provides
a menu for the user to check balance, withdraw, deposit and offer time to 
other users. 

The Timebank is stored in 'Users'.'timebank' in the database.

=end

class TimebankController < Tgcontroller

  def menu
    done = false
    validkeys=['B','D','O','W','X']
    until done == true
      key = Tgio::Input.menuprompt('menu_timebank.ftl',validkeys, nil) # nil is for tpl vars hash
      print "\n"
      case key
        when "B" # Show Time Bank Balance
          self.showbalance
        when "D" # Deposit
          self.deposit
        when "G" # Give time slices to other users
        when "W" # Withdraw from timebank
          self.withdraw
        when "X" # Quit time bank menu
          return 0
      end #/case
    end #/until
  end #/def menu

  # Show balance for the current user 
  def showbalance
    curuser = User.where(:id => $session.user_id).first
    Tgtemplate.display('timebank_balance.ftl', {'balance' => curuser.timebank.to_s})
  end 

  # User makes a deposit in the bank
  # TODO: A potential bug exists in 'deposit' and 'withdraw'
  #   - if a user adds a minus or non-numeric character, it could cheat the bank or cause a crash.
  #   - fix the question dialog in 'askamount' to input and test only for numbers
  def deposit
    # TODO: Check the GROUP limits and enforce
    maxbalance = $cfg['limits']['timebank_max']
    curuser = User.where(:id => $session.user_id).first
    balance = curuser.timebank
    remain = $session.timeremain
    amount = self.askamount

    # Verify the amount deposited is available from the current session and will not exceed the system defined limit
    if (balance + amount > maxbalance)
      Tgtemplate.display('timebank_limit_exceeded.ftl', {'amount' => amount.to_s, 'maxbalance'=>maxbalance.to_s})
    elsif (amount > remain )
      Tgtemplate.display('timebank_insufficent_funds.ftl', {'amount' => amount.to_s, 'remain'=>remain.to_s})
    else
      # If ok, then deduct from the session & update the user's timebank balance.
      $session.timeadjust(-amount)
      curuser.timebank = (curuser.timebank + amount)
      Tgtemplate.display('timebank_deposit.ftl', {'amount' => amount.to_s, 'remain'=>$session.timeremain.to_s})
      curuser.save
    end
  end

  # User withdraws from the bank
  def withdraw
    curuser = User.where(:id => $session.user_id).first
    balance = curuser.timebank
    amount = self.askamount
    # Verify the user has enough available balance
    if amount > balance
      Tgtemplate.display('timebank_insufficent_funds.ftl', {'amount' => amount.to_s, 'remain'=>balance.to_s})
    else
      # If ok, then withdraw from the bank balance & update the user's session time remaining.
      curuser.timebank = (curuser.timebank - amount)
      $session.timeadjust(+amount)
      Tgtemplate.display('timebank_withdraw.ftl', {'amount' => amount.to_s, 'remain'=>$session.timeremain.to_s})
      curuser.save
    end
  end

  # Asks user for the amount to be deposit/withdraw/lend
  # TODO: Fix the input to allow ONLY positive integer values
  def askamount(val=nil)
    complete = false
    until complete == true
      amount = Tgio::question('timebank_askamount.ftl', 3, 'posint')
      unless amount.is_blank?
        complete = true if amount.is_alphanumeric?
      end #/if
    end #/until
    return amount.to_i
end #/def askpostal

end
