#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);

sub WT_main
{
  my $ACTION = 'https://merchant.webmoney.ru/lmi/payment.asp?at=authtype_8';
  my $STAT_URL = "http://STATLINK$script?uu=$F{uu}&pp=$F{pp}&a=$F{a}";
  my $LMI_RESULT_URL = "http://STATLINK/cgi-bin/webmoney.pl";
  my $LMI_PAYEE_PURSE = 'WMNUMBER';

  &OkMess('������ ����������� �������') if ($F{result} eq 'success');
  &ErrorMess('������ ������ ���� �����') if ($F{result} eq 'fail');
  
  $paket=&sql_select_line($dbh, "SELECT price FROM plans2 WHERE id='$pm->{paket}'");

  &Message(
    "<h2>������ ����� ��������� ��������� �������</h2><br>
     <form name=\"payform\" onsubmit=\"if (document.forms.payform.amount.value < 10) {alert('����� ������ 10'); return false; } else return true;\" method=post action=\"$ACTION\">
      <input type=\"hidden\" name=\"LMI_ALLOW_SDP\" value=\"8\">
      <input type=\"hidden\" name=\"LMI_PAYEE_PURSE\" value=\"$LMI_PAYEE_PURSE\">
      <input type=\"hidden\" name=\"LMI_PAYMENT_NO\" value=\"$Mid\">
      <input type=\"hidden\" name=\"LMI_PAYMENT_DESC\" value=\"������ �� ������ ($pm->{fio})\">
      <input type=\"hidden\" name=\"LMI_RESULT_URL\" value=\"$LMI_RESULT_URL\">
      <input type=\"hidden\" name=\"LMI_SUCCESS_URL\" value=\"$STAT_URL&result=success\">
      <input type=\"hidden\" name=\"LMI_FAIL_URL\" value=\"$STAT_URL&result=fail\">
      <span><b>���:</b> $pm->{fio}</span><br>
      <span><b>����� ��������:</b> $pm->{name}</font></span><br><br>
      <span><b>������� ����� ��� ������:</span><br><br>
      <input type=\"text\" name=\"LMI_PAYMENT_AMOUNT\" value=\"$paket->{price}\">&nbsp$gr<br><br>
      <input type=\"submit\" value=\"������� � ������\">
    </form>");
}

1;
