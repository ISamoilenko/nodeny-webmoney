#!/usr/bin/perl

use DBI;
use Time::localtime;
use Time::Local;
use MIME::Base64;
use Digest::SHA qw(sha256_hex);
use CGI;

my $LMI_PAYEE_PURSE = 'WMNUMBER';
my $CATEGORY = 'CATEGORY';
my $LMI_SECRET_KEY = 'SECRETKEY';
my $LOG_FILE = '/usr/local/nodeny/module/webmoney.log';

$c=new CGI;

sub debug
{
  my ($time);
  open LOG, ">>$LOG_FILE";
  $time = CORE::localtime;
  print LOG "$time: $_[0]\n";
  $c->save(\*LOG);
  close LOG;
}

sub return_ok
{
  debug "OK";
  print "Content-type: text/html; charset=windows-1251;\n\nYES\n";
  exit;
}

sub return_fail
{
  debug $_[0];
  print "Content-type: text/html; charset=windows-1251;\n\nFAIL:$_[0]\n";
  exit;
}

require '/usr/local/nodeny/nodeny.cfg.pl';
$dbh=DBI->connect("DBI:mysql:database=$db_name;host=$db_server;mysql_connect_timeout=$mysql_connect_timeout;",$user,$pw,{PrintError=>1});
die "Connection to database failed" unless $dbh;
require '/usr/local/nodeny/web/calls.pl';


return_fail "LMI_PAYEE_PURSE" unless $LMI_PAYEE_PURSE eq $c->param('LMI_PAYEE_PURSE');
$AMOUNT = $c->param('LMI_PAYMENT_AMOUNT');
return_fail "LMI_PAYMENT_AMOUNT" unless $AMOUNT =~ /^\d+(\.\d{1,2}){0,1}$/;
$MID = $c->param('LMI_PAYMENT_NO');
return_fail "LMI_PAYMENT_NO" unless $MID =~ /^\d+$/;
return_fail "LMI_PAYMENT_NO" unless &sql_select_line($dbh, "SELECT * FROM users WHERE id='$MID' AND mid='0'");

return_ok if $c->param('LMI_PREREQUEST') eq '1';

my @HASH = (
  $c->param('LMI_PAYEE_PURSE'),
  $c->param('LMI_PAYMENT_AMOUNT'),
  $c->param('LMI_PAYMENT_NO'),
  $c->param('LMI_MODE'),
  $c->param('LMI_SYS_INVS_NO'),
  $c->param('LMI_SYS_TRANS_NO'),
  $c->param('LMI_SYS_TRANS_DATE'),
  $LMI_SECRET_KEY,
  $c->param('LMI_PAYER_PURSE'),
  $c->param('LMI_PAYER_WM')
);
return_fail "LMI_HASH" unless uc(sha256_hex(join('', @HASH))) eq uc($c->param('LMI_HASH'));

$TRANS = $c->param('LMI_SYS_TRANS_NO');
$INVS = $c->param('LMI_SYS_INVS_NO');
$TRANS_DATE = $c->param('LMI_SYS_TRANS_DATE');

#return_ok if (&sql_select_line($dbh, "SELECT mid FROM pays WHERE reason='$TRANS' AND type=10 AND category='$CATEGORY' LIMIT 1"));

&sql_do($dbh, "INSERT INTO pays SET
                mid='$MID',
                cash='$AMOUNT',
                time=UNIX_TIMESTAMP(NOW()),
                admin_id=0,
                admin_ip=0,
                office=0,
                bonus='y',
                reason='$TRANS',
                coment='Ïåðåâîä WebMoney (ñ÷åò: $INVS, òðàíçàêöèÿ: $TRANS)',
                type=10,
                category='$CATEGORY'");

&sql_do($dbh, "UPDATE users SET state='on', balance=balance+$AMOUNT WHERE id='$MID'");

return_ok;
