#!/usr/bin/perl -w

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
print "Content-type: text/html\n\n";


# You can set the page title here
$PAGE_TITLE  = "Informacoes de ambiente e modulos Perl instalados - LocaWeb";



#Location of Perl
$whereperl      = join("<BR>", split(/\s+/, qx/whereis perl/));

#Location of Sendmail
$wheresendmail  = join("<BR>", split(/\s+/, qx/whereis sendmail/));

#Location of Current Directory
$currentdirectory = `pwd`;

# List of processes
#$processes = qx/ps aux/;
$processes =~ s/<br>/\n/gi;
$processes =~ s/<br>/\n\n/gi;
$processes =~ s/<(?:[^>'"]*|(['"]).*?\1)*>//gs;

#Perl Variables
$perlversion = $];

$path_tar       = join("<BR>", split(/\s+/, qx/whereis tar/));
$path_gzip      = join("<BR>", split(/\s+/, qx/whereis gzip/));
$path_apache    = join("<BR>", split(/\s+/, qx/whereis apache/));
$path_httpd     = join("<BR>", split(/\s+/, qx/whereis httpd/));
$path_php       = join("<BR>", split(/\s+/, qx/whereis php/));
$path_mysql     = join("<BR>", split(/\s+/, qx/whereis mysql/));
$path_man       = join("<BR>", split(/\s+/, qx/whereis man/));
$path_perldoc   = join("<BR>", split(/\s+/, qx/whereis perldoc/));
$path_java              = join("<BR>", split(/\s+/, qx/whereis java/));


#Perl Os
$perlos = $^O;
$perlos_version = get_server('version');
$perlos_version =~ s/#/<BR>#/s;
$perlos_version =~ s/\(/<BR>(/s;

#$perlos_cpu     = get_server_detail('cpuinfo');
#$perlos_mem     = get_server_detail('meminfo');
#$perlos_mem     =~ s/^.*?\n.*?\n.*?\n//s;
#$perlos_dsk     = `df`;

sub get_server
{
    open PROC, "</proc/$_[0]" || &error("Cannot read proc [/proc/$_[0]]", $!);
    my $res = join("<BR>", <PROC>);
    close PROC;
    return $res ? $res : undef;
}
sub get_server_detail
{
    open PROC, "</proc/$_[0]" || &error("Cannot read proc [/proc/$_[0]]", $!);
    my $res = join("", <PROC>);
    close PROC;
    return $res ? $res : undef;
}


#Module Paths
foreach $line (@INC)
        {
        $modulepaths .= "$line<br>";
        }

#Environment Variables
$environment = qq~
<table width="69%" align="center"  cellspacing="0" cellpadding="4" bordercolor="#c5c5c5">
<tr>
<td colspan="2" bgcolor="#FCB0000" class="tabletitle">VARIAVEIS DE AMBIENTE <a href="#top" title="Back to top"></font></a> </td>
</tr>
~;

#$PAGE_FOOTER = "Powered by <a href='http://sniptools.com/perldigger'>Get PERL DIGGER (it's free!)</a>   |   Copyright © <a href='http://shanx.com'>Shashank Tripathi </a>";

@allkeys = keys(%ENV);
foreach  $key (@allkeys)
{
$value = $ENV{$key};
if ($value eq "") {$value = "-";}
$environment .= qq~
<tr>
<td width="168" class="tableitems">$key</td>
<td class="tablevalue">$value</td>
</tr>
~;
}
$environment .= qq~
</table>
~;


$documentroot = $ENV{'DOCUMENT_ROOT'};
if ($documentroot ne "")
{
@lines = `du -c -k $documentroot`;
$lastline = @lines-1;
#($diskusage) = split/[\t| ]/,$lines[$lastline];
}

#Server Software
$serverip = $ENV{'SERVER_ADDR'};
$servername = $ENV{'SERVER_NAME'};
$serverport = $ENV{'SERVER_PORT'};

$serversoftware = $ENV{'SERVER_SOFTWARE'};

$serveruptime =`uptime`;


#Localtime
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
@months = ("Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez");
$date = sprintf("%02d-%s-%04d",$mday,$months[$mon],$year+1900);
$time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
$localtime = "$date, $time";

#GMTtime
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);
@months = ("Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez");
$date = sprintf("%02d-%s-%04d",$mday,$months[$mon],$year+1900);
$time = sprintf("%02d:%02d:%02d",$hour,$min,$sec);
$gmttime = "$date, $time";


print qq~
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

    <title>$PAGE_TITLE</title>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="PICS-Label" content=' (PICS-1.1 "http://www.gcf.org/v2.5" labels on "2001.11.05T08:15-0500" until "1995.12.31T23:59-0000" for "http://w3.org/PICS/Overview.html" ratings (suds 0.5 density 0 color/hue 1))'>



<style type="text/css">
<!--
h1          {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }
.tabletitle {  font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; height: 22px; color:#FFFFFF;}
.tableitems {  font-family: Arial, Helvetica, sans-serif; font-weight: bold; font-size: 11px; border-bottom: 1px #efefef solid;}
.tablevalue {  font-family: Arial, Helvetica, sans-serif; font-size: 11px; border-bottom: 1px #C6CDCE solid;}
a           {  color: #3366FF; }
a:hover     {  text-decoration: none; color: #ff6600;}
td          {  font-family: Arial, Helvetica, sans-serif; font-size: 11px }
table       {  border: 1px #C6CDCE solid; background-color: #E6ECEC }
-->
</style>
</head>

<body bgcolor="#FFFFFF" text="#000000" background="http://sniptools.com/av/bg.gif"><a name="top"></a><br>
<!--<center><img src="./logolw.jpg"></center>-->

<table width="69%" align="center"  cellpadding="4" cellspacing="0">
<tr><!--<td  height="51" width="168" valign="top" background="http://sniptools.com/av/bg_grey.gif"><h1 style="margin-bottom: 3px">Perl Digger</h1>
<a href="http://sniptools.com/code/perldigger.txt">Get Perl code here</a></td>--> <td  valign="middle" background="http://sniptools.com/av/bg_grey.gif"><b style="font-size: 16px;font-wight:bold; "><center>Informacoes sobre o servidor,
 variaveis de ambiente e todos os modulos Perl instalados</center>
 </b> </tr>
  <tr>
    <td colspan="2" height="60" align="center" valign="middle">
            <a href="#perlinfo"><b style="font-wight:bold;">INFORMACOES PERL<b></a>
          |   <a href="#serverinfo"><b style="font-wight:bold;">INFORMACOES SOBRE SERVIDOR</b></a>
          |   <a href="#env"><b style="font-wight:bold;">VARIAVEIS DE AMBIENTE</b></a>
          |   <a href="#modules"><b style="font-wight:bold;">MODULOS PERL INSTALADOS</b></a>
    </td>
  </tr>
</table>

<br>
<a name="perlinfo"></a><br>

<table width="69%" align="center"  cellpadding="4" cellspacing="0">
  <tr bgcolor="#FCB0000">
    <td colspan="2" class="tabletitle">
      PERL <a href="#top" title="Back to top"></font></a>

    </td>  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Perl version</td>
    <td class="tablevalue">$perlversion</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Perl</td>
    <td class="tablevalue">$whereperl</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Sendmail</td>
    <td class="tablevalue">$wheresendmail</td>
  </tr>
</table>
<br>
<a name="serverinfo"></a><br>

<table width="69%" align="center"  cellspacing="0" cellpadding="4" bordercolor="#c5c5c5">
  <tr bgcolor="#FCB0000">
    <td colspan="2" class="tabletitle">

      INFORMACOES DO SERVIDOR   <a href="#top" title="Back to top"></font></a>

    </td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Name</td>
    <td class="tablevalue">$servername</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">IP</td>
    <td class="tablevalue">$serverip</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Listing Port</td>
    <td class="tablevalue">$serverport</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Document Root</td>
    <td class="tablevalue">$documentroot</td>
  </tr>
  <tr>
  <!--
        <td class="tableitems" width="168" valign="top">Disk Usage by Root</td>
    <td class="tablevalue">$diskusage KB</td>
  -->
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Server stamp</td>
    <td class="tablevalue">$serversoftware</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Server Time (Local)</td>
    <td class="tablevalue">$localtime</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Server Time (GMT)</td>
    <td class="tablevalue">$gmttime</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Server Details </td>
    <!--

        <td class="tablevalue">
        <p><strong>OPERATING SYSTEM:</strong><br>$perlos_version
        <p><strong>CPU UTILIZATION:</strong><br><textarea rows=10 cols=60>$perlos_cpu</textarea>
        <p><strong>MEMORY UTILIZATION:</strong><br><textarea rows=10 cols=60>$perlos_mem</textarea>
<p><strong>DISK UTILIZATION:</strong><br><textarea rows=10 cols=60 wrap="OFF">TOTAL DISK USAGE:\n$diskusage KB \n\n$perlos_dsk</textarea>
    </td>
          -->

  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Module Paths</td>
    <td class="tablevalue">$modulepaths</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Path(s) to TAR</td>
    <td class="tablevalue">$path_tar</td>
  </tr>
    <tr>
    <td class="tableitems" width="168" valign="top">Path(s) to GZIP</td>
    <td class="tablevalue">$path_gzip</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Path to APACHE/HTTPD</td>
    <td class="tablevalue">$path_apache<p>$path_httpd</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Path to PHP</td>    <td class="tablevalue">$path_php</td>
  </tr>
    <tr>
    <td class="tableitems" width="168" valign="top">Path to Java</td>
    <td class="tablevalue">$path_java</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Path to MYSQL</td>
    <td class="tablevalue">$path_mysql</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Path to MAN (Unix manual)</td>
    <td class="tablevalue">$path_man</td>
  </tr>
  <tr>
    <td class="tableitems" width="168" valign="top">Path to PERLDOC</td>
    <td class="tablevalue">$path_perldoc</td>
  </tr>
  <tr>
<!--
  <td class="tableitems" width="168" valign="top">Processes currently on the server</td>
  <td class="tablevalue"><textarea rows=10 cols=60 wrap="OFF">$processes</textarea> </td>
-->
  </tr>
</table>

<br>
<a name="env"></a><br>
$environment

<!-- ALL MODULES -->
<a name="modules"></a><br>
<table width="69%" align="center"  cellspacing="0" cellpadding="4" bordercolor="#c5c5c5">
  <tr bgcolor="#FCB0000">
    <td colspan="2" class="tabletitle">
      MODULOS PERL <a href="#top" title="Back to top"></font></a>
    </td>
  </tr>
  <tr>
    <td>

~;

&vars;
find(\&wanted,@INC);
$modcount = 0;
foreach $line(@foundmods)
{
    $match = lc($line);
    if ($found{$line}[0] >0)
    {$found{$line} = [$found{$line}[0]+1,$match]}
    else
    {$found{$line} = ["1",$match];$modcount++}
}
@foundmods = sort count keys(%found);

sub count
{
    return $found{$a}[1] cmp $found{$b}[1]

}
$third = $modcount/3;
$count=0;
$firstroundtotal = 0;

    foreach $mod(@foundmods)
    {
        chomp $mod;
        $count++;
        if ($count <= $third)
        {
            $firstroundtotal++;
            print qq~
             $firstroundtotal. <a href="http://search.cpan.org/search?module=$mod" title="Click here to see $mod on CPAN
[Opens in a new window]" target="_blank">$mod</a><br>

            ~;
        }
        else
        {
            push (@mod1,$mod)
        }
    }

        $count = 0;
        print qq~ </td><td>~;
        foreach $mod1(@mod1)
        {
            chomp $mod1;
            $count++;
            if ($count <= $third){}
            else {

                push (@mod2,$mod1)}}$count = 0;
                foreach $mod2(@mod2)
                {       chomp $mod2;    $count++;       if ($count <= $third)
                {
                $firstroundtotal++;
                print qq~
                 $firstroundtotal. <a href="http://search.cpan.org/search?module=$mod2" title="Click here to see $mod2 on CPAN
[Opens in a new window]" target="_blank">$mod2</a><br>~;        }};
sub vars {use File::Find;}
sub wanted { $count = 0; if ($File::Find::name =~ /\.pm$/) { open(MODFILE,$File::Find::name) || return;
while(<MODFILE>){ if (/^ *package +(\S+);/){
push (@foundmods, $1); last; } } } }
print qq~
    </td>
  </tr>
</table>

<p class="tablevalue"> </p>
<p class="tablevalue" align="center"><a href="#top" title="Back to top"></font></a> $PAGE_FOOTER</p><br><p>
</body>
</html>
~;
