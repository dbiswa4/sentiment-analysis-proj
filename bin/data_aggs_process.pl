#!/usr/bin/perl

use Getopt::Long;
use DBI;


BEGIN{$|=1}

#`>  2>&1`

print "Start Perl Script\n";
print "Call Hive Script\n";

`nohup /home/ec2-user/apache-hive-0.14.0-bin/bin/hive -f /home/ec2-user/BDAAProject/hive/tweets_analytics_agg.hql`;

print "Hive return code : $?\n";

if($? != 0 ) {
exit(1);
}
my $temp_dir = '/home/ec2-user/BDAAProject/temp';

my $geo_positive_dir = '/home/ec2-user/BDAAProject/output/geo_positive';
my $geo_negative_dir = '/home/ec2-user/BDAAProject/output/geo_negative';
my $geo_total_dir = '/home/ec2-user/BDAAProject/output/geo_total';
my $temporal_dir = '/home/ec2-user/BDAAProject/output/temporal';

my $geo_positive_file = join '',$temp_dir,'/','geo_positive.dat';
my $geo_negative_file = join '',$temp_dir,'/','geo_negative.dat';
my $geo_total_file = join '',$temp_dir,'/','geo_total.dat';
my $temporal_file = join '',$temp_dir,'/','temporal.dat';

print "$geo_positive_file\n";
print "$geo_negative_file\n";
print "$geo_total_file\n";
print "$temporal_file\n";

`cat $geo_positive_dir/* > $geo_positive_file`;
`cat $geo_negative_dir/* > $geo_negative_file`;
`cat $geo_total_dir/* > $geo_total_file`;
`cat $temporal_dir/* > $temporal_file`;



$mysql_dbh = '';
$MYSQL_DATABASE='projects';
$MYSQL_HOSTNAME='ec2-52-33-70-93.us-west-2.compute.amazonaws.com';
$MYSQL_USERNAME='projects';
$MYSQL_PASSWORD='projects';

my $geop_qry_template="INSERT INTO geo_positive (`contestant`, `user_location`, `create_date`, `count`) VALUES ('%s','%s','%s','%d') ON DUPLICATE KEY UPDATE `count`=VALUES(`count`)";

my $geon_qry_template="INSERT INTO geo_negative (`contestant`, `user_location`, `create_date`, `count`) VALUES ('%s','%s','%s','%d') ON DUPLICATE KEY UPDATE `count`=VALUES(`count`)";

my $geot_qry_template="INSERT INTO geo_total (`contestant`, `user_location`, `create_date`, `count`) VALUES ('%s','%s','%s','%d') ON DUPLICATE KEY UPDATE `count`=VALUES(`count`)";

my $temporal_qry_template="INSERT INTO temporal (`contestant`, `create_date`, `create_hour`, `sentiment`, `count`) VALUES ('%s','%s','%s','%s', '%d') ON DUPLICATE KEY UPDATE `count`=VALUES(`count`)";

open(GEOP, "$geo_positive_file") or die "Couldn't geo_positive open file, $!";
open(GEON, "$geo_negative_file") or die "Couldn't geo_negative open file, $!";
open(GEOT, "$geo_total_file") or die "Couldn't geo_total open file, $!";
open(TEMP, "$temporal_file") or die "Couldn't geo_total open file, $!";


while(my $line = <GEOP>){
	
	#print "GEOP line : $line\n";
	my ($contestant, $user_location, $create_date, $count) = split ",", $line;
	database_action($geop_qry_template,$contestant, $user_location, $create_date, $count);

}

print "GEOP file processing done\n";

close GEOP;

while(my $line = <GEON>){
	#print "GEON line : $line\n";
        my ($contestant, $user_location, $create_date, $count) = split ",", $line;
        database_action($geon_qry_template,$contestant, $user_location, $create_date, $count);

}

print "GEON file processing done\n";

close GEON;

while(my $line = <GEOT>){
	#print "GEOT line : $line\n";
        my ($contestant, $user_location, $create_date, $count) = split ",", $line;
        database_action($geot_qry_template,$contestant, $user_location, $create_date, $count);

}

print "GEOT file processing done\n";

close GEOT;


while(my $line = <TEMP>){
        #print "TEMP line : $line\n";
        my ($contestant, $create_date, $create_hour, $sentiment, $count) = split ",", $line;
        database_action_temp($temporal_qry_template, $contestant, $create_date, $create_hour, $sentiment, $count);

}

print "TEMP file processing done\n";

close TEMP;


clean_up();
exit(0);

####-------######

#Database Update
sub database_action{
	print "In database_action()\n";

	my ($qry_template, $contestant, $user_location, $create_date, $count) = @_;

	if($mysql_dbh =~ /^\s*$/){
		print "Connect to Database\n";

		$mysql_dbh = DBI->connect("DBI:mysql:$MYSQL_DATABASE;host=$MYSQL_HOSTNAME", $MYSQL_USERNAME, $MYSQL_PASSWORD, {
		RaiseError => 0,
		PrintError => 0
		});
	
		print "DBI::err : $DBI::err\n";
		print "DBI::errstr : $DBI::errstr\n";
	
		print "mysql_dbh = $mysql_dbh\n";
	}

	my $qry = sprintf($qry_template, $contestant, $user_location, $create_date, $count);

	print "qry to be executed : \n$qry\n";

	$mysql_dbh->do($qry);

	print "After Insert query:\n";	
	
	print "DBI::err : $DBI::err\n";
        print "DBI::errstr : $DBI::errstr\n";
	
}

##Database Update for Temporal table
sub database_action_temp{
        print "In database_action_temp()\n";

        my ($qry_template, $contestant, $create_date, $create_hour, $sentiment, $count) = @_;

        if($mysql_dbh =~ /^\s*$/){
                print "Connect to Database\n";

                $mysql_dbh = DBI->connect("DBI:mysql:$MYSQL_DATABASE;host=$MYSQL_HOSTNAME", $MYSQL_USERNAME, $MYSQL_PASSWORD, {
                RaiseError => 0,
                PrintError => 0
                });

                print "DBI::err : $DBI::err\n";
                print "DBI::errstr : $DBI::errstr\n";

                print "mysql_dbh = $mysql_dbh\n";
        }

        my $qry = sprintf($qry_template, $contestant, $create_date, $create_hour, $sentiment, $count);

        #print "qry to be executed : \n$qry\n";

        $mysql_dbh->do($qry);

        print "After Insert query:\n";

        print "DBI::err : $DBI::err\n";
        print "DBI::errstr : $DBI::errstr\n";

}


sub clean_up(){
	print "\nIn clean_up()\n";
 
	if($mysql_dbh =~ /^\s*$/){
		print "No Database Connection exists\n";	
	} else {
		$mysql_dbh->disconnect;		
		print "Database Connection Closed : $mysql_dbh\n";
	}
	
	print "Reached end-of-program. It will End now. Bye\n";
}

