package server;

import sys.io.File;
import format.csv.*;
import haxe.Json;
import shared.Score;
import sys.io.FileOutput;

class Main
{
	private var _scores		: Array<Score>;
	
	var filePath			: String = "D:/scores.txt";
	
	static function main()
	{
		var context = new haxe.remoting.Context();
		context.addObject("Server", new Main());
		
		if (haxe.remoting.HttpConnection.handleRequest(context))
		{
			return;
		}
		
		trace("Server started");
	}

	function new() {
		_scores = loadScoreFromFile();
	}
	
	function loadScoreFromFile()
	{
		var scores = new Array<Score>();
		
		var content = File.getContent(filePath);
		var scoresCSV = Reader.parseCsv(content, ";");
		
		for (scoreCSV in scoresCSV)
		{
			var nickname = scoreCSV[0];
			var time = Std.parseFloat(scoreCSV[1]);
			var date = Std.parseFloat(scoreCSV[2]);
			
			var score = {nickname: nickname, time: time, date: date};
			
			scores.push(score);
		}
		
		return scores;
	}

	function getScores():Array<Score>
	{
		return _scores;
	}
	
	private function sendScore(score:Score):Bool
	{
		// Ne pas faire de print, ça compte comme un return :/
		
		score.nickname = StringTools.replace(score.nickname, ";", "");
		score.nickname = StringTools.replace(score.nickname, "\r", "");
		score.nickname = StringTools.replace(score.nickname, "\n", "");
		score.nickname = StringTools.replace(score.nickname, "\"", "");
		
		var output:FileOutput = File.append(filePath, false);
		var line = '"${score.nickname}";${score.time};${score.date}\n';
		output.writeString(line);
		output.close();
		
		_scores = loadScoreFromFile();
		
		// TODO: renvoyer false si ça bug
		return true;
	}
}