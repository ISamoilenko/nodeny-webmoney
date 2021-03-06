#!/usr/bin/perl

use Digest::SHA qw(sha256_hex);

sub WM_main
{
  my $ACTION = 'https://merchant.webmoney.ru/lmi/payment.asp';
  my $STAT_URL = "http://STATLINK$script?uu=$F{uu}&pp=$F{pp}&a=$F{a}";
  my $LMI_RESULT_URL = "http://STATLINK/cgi-bin/webmoney.pl";
  my $LMI_PAYEE_PURSE = 'WMNUMBER';

  &OkMess('Îïëàòà ïðîèçâåäåíà óñïåøíî') if ($F{result} eq 'success');
  &ErrorMess('Îøèáêà îïëàòû ëèáî îòêàç') if ($F{result} eq 'fail');
  
  $paket=&sql_select_line($dbh, "SELECT price FROM plans2 WHERE id='$pm->{paket}'");

  &Message(
    "<h2>Îïëàòà ÷åðåç ïëàòåæíóþ ñèñòåìó WebMoney</h2><br>
     <form name=\"payform\" onsubmit=\"if (document.forms.payform.amount.value < 10) {alert('Ñóììà ìåíüøå 10'); return false; } else return true;\" method=post action=\"$ACTION\">
      <input type=\"hidden\" name=\"LMI_PAYEE_PURSE\" value=\"$LMI_PAYEE_PURSE\">
      <input type=\"hidden\" name=\"LMI_PAYMENT_NO\" value=\"$Mid\">
      <input type=\"hidden\" name=\"LMI_PAYMENT_DESC\" value=\"Îïëàòà çà óñëóãè ($pm->{fio})\">
      <input type=\"hidden\" name=\"LMI_RESULT_URL\" value=\"$LMI_RESULT_URL\">
      <input type=\"hidden\" name=\"LMI_SUCCESS_URL\" value=\"$STAT_URL&result=success\">
      <input type=\"hidden\" name=\"LMI_FAIL_URL\" value=\"$STAT_URL&result=fail\">
      <span><b>ÔÈÎ:</b> $pm->{fio}</span><br>
      <span><b>Íîìåð äîãîâîðà:</b> $pm->{name}</font></span><br><br>
      <span><b>Ââåäèòå ñóììó äëÿ îïëàòû:</span><br><br>
      <input type=\"text\" name=\"LMI_PAYMENT_AMOUNT\" value=\"$paket->{price}\">&nbsp$gr<br><br>
      <input type=\"submit\" value=\"Ïåðåéòè ê îïëàòå\">
    </form>");
}

1;
