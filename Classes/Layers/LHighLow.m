//
//	Created by mtt on 12/07/09
//
//	Project: intothefire
//	File: LHighLow.m
//
//	Last modified: 12/07/09
//

#import "LHighLow.h"


@implementation LHighLow

- (id) init {
    self = [super init];
    if (self != nil) {
       
    }
    return self;
}

@end


/*
 <?php
 
 session_register("game_status");
 session_register("actual_number");
 session_register("score");
 session_register("lives");
 session_register("next_extra");
 
 $connection = mysql_connect(localhost, "****", "****");
 $db= mysql_select_db(*****,$connection);
 
 $old_number = $actual_number;
 $actual_number = rand(0,9);
 
 
 $page_name = $PHP_SELF;
 
 if($guess == "new"){
 if($_POST[name]){
 $_POST[name] = substr(strip_tags($_POST[name]),0,20);
 $sql = "insert into ****(***,***) values(\"".stripslashes($_POST[name])."\",$score)";
 $result = mysql_query($sql,$connection) or die($sql);
 }
 $game_status = "NOT_PLAYING";
 }
 
 if(!isset($game_status)){
 $game_status = "NOT_PLAYING";
 }
 
 if($game_status == "NOT_PLAYING"){
 $lives = 3;
 $score = 0;
 $next_extra = 3;
 $class_to_show = "number";
 if(($guess=="bigger")or($guess=="smaller")){
 $game_status = "PLAYING";
 $sql = "update *** set *** = ***+ 1";
 $result = mysql_query($sql,$connection) or die($sql);
 //	echo $sql;
 }
 else{
 if(isset($old_number)){
 $actual_number = $old_number;
 }
 }
 }
 
 if($game_status == "PLAYING"){
 if ((($guess == "bigger") and ($actual_number >= $old_number)) or (($guess == "smaller") and ($actual_number <= $old_number))){
 $score ++;
 $class_to_show = "number";
 $game_status = "PLAYING";
 if ($score == $next_extra){
 $lives +=1;
 $next_extra = floor($next_extra*1.5);
 }
 }
 else{
 $lives -=1;
 $class_to_show = "number_wrong";
 if ($lives==0){
 $game_status = "GAME_OVER";
 $perso_ora = true;
 }
 }
 }
 
 if ($game_status == "GAME_OVER"){
 $class_to_show = "number_wrong";
 if(!$perso_ora){
 $actual_number = $old_number;
 }
 }
 
 //echo $game_status;
 
 ?>
 
 <html>
 <head>
 <style>
 
 h1{
 color:#c4c41f;
 font-size: 20;
 }
 
 .container{
 background-color: #000000;
 padding: 30px;
 border: 2px solid #c43d1f;
 width: 600px;
 height: 450px;
 font-family: verdana;
 font-size: 12px;
 color:c43d1f;
 font-weight: bold;
 text-align:center;
 }
 
 .number{
 color:579331;
 font-family: verdana;
 font-size: 128px;
 border: 1px solid #c43d1f;
 margin-left: 140px;
 margin-right: 140px;
 margin-top: 15px;
 margin-bottom: 15px;
 background-color:#ffffff;
 }
 
 .number_wrong{
 color:#c43d1f;
 font-family: verdana;
 font-size: 128px;
 border: 1px solid #c43d1f;
 margin-left: 140px;
 margin-right: 140px;
 margin-top: 15px;
 margin-bottom: 15px;
 background-color:#ffffff;
 }
 
 a:link,a:visited{
 padding: 10px;
 margin: 15px;
 border: 1px dotted #c43d1f;
 width = 130px;
 text-align:center;
 text-decoration:none;
 font-size: 18;
 color:#579331;
 }
 
 .score{
 padding: 5px;
 margin: 10px;
 border: 1px solid #c43d1f;
 text-align:center;
 font-size: 15;
 color:#c4c41f;
 }
 
 a:hover{
 padding: 10px;
 margin: 15px;
 border: 1px dotted #c43d1f;
 width = 130px;
 text-align:center;
 text-decoration:none;
 background-color:#ffffff;
 font-size: 18;
 color:579331;
 }
 
 ul
 {
 padding-left: 0;
 margin-left: 0;
 float: left;
 width: 100%;
 }
 
 
 li{
 display: inline;
 }
 
 body{
 font-family: sans-serif;
 text-align:center;
 background-color:#cccccc;
 }
 
 </style>
 </head>
 <body onload = "self.focus()">
 <div class = "container">
 <h1>WELCOME TO PHP-MAGORMIN v1.0</h1>
 <?php echo "<ul><li class =\"score\">Score: $score<li class = \"score\">Lives: $lives<li class = \"score\">Extra life at $next_extra</ul>"; ?>
 <br><br>CURRENT NUMBER
 <div class = "<?php echo $class_to_show; ?>"><?php echo $actual_number; ?></div>
 <?php
 if($game_status == "PLAYING"){
 ?>
 I guess next number will be
 <ul><li><a href = "<?php echo $page_name; ?>?guess=smaller">SMALLER</a><li><a href = "<?php echo $page_name; ?>?guess=bigger">BIGGER</a></ul>
 <?php } ?>
 <?php
 if($game_status == "GAME_OVER"){
 ?>
 GAME OVER<br>
 <form action = "" method = "post">Enter your name: <input name = "name" type = "text"><input type = "hidden" name ="guess" value = "new"> <input type = "submit" value = "go"></form>
 <?php } ?>
 <?php
 if($game_status == "NOT_PLAYING"){
 ?>
 I guess next number will be
 <ul><li><a href = "<?php echo $page_name; ?>?guess=smaller">SMALLER</a><li><a href = "<?php echo $page_name; ?>?guess=bigger">BIGGER</a></ul>
 
 <?php } ?>
 
 </div>
 </body>
 </html>
*/