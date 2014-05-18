package com.finegamedesign.recyclesort
{
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.text.TextField;
    import flash.utils.getTimer;

    import org.flixel.system.input.KeyMouse;
    import org.flixel.plugin.photonstorm.API.FlxKongregate;
    // import com.newgrounds.API;

    public dynamic class Main extends MovieClip
    {
        [Embed(source="../../../../sfx/breathin.mp3")]
        private static var airPocketClass:Class;
        internal var airPocket:Sound = new airPocketClass();
        [Embed(source="../../../../sfx/chime.mp3")]
        private static var completeClass:Class;
        internal var complete:Sound = new completeClass();
        [Embed(source="../../../../sfx/chime.mp3")]
        private static var selectClass:Class;
        internal var select:Sound = new selectClass();
        [Embed(source="../../../../sfx/die.mp3")]
        private static var wrongClass:Class;
        internal var wrong:Sound = new wrongClass();
        [Embed(source="../../../../sfx/getPearl2.mp3")]
        private static var correctClass:Class;
        internal var correct:Sound = new correctClass();
        [Embed(source="../../../../sfx/wavesloop.mp3")]
        private static var loopClass:Class;
        internal var loop:Sound = new loopClass();
        [Embed(source="../../../../sfx/oxygen dwon.mp3")]
        private static var strokeClass:Class;
        internal var stroke:Sound = new strokeClass();

        private var loopChannel:SoundChannel;

        public var answerClip:MovieClip;
        public var feedback:MovieClip;
        public var score_txt:TextField;
        public var levelScore_txt:TextField;
        public var restartTrial_btn:SimpleButton;
        public var input:MovieClip;
        public var head:DisplayObjectContainer;

        internal var keyMouse:KeyMouse;
        private var inTrial:Boolean;
        private var level:int;
        private var maxLevel:int;
        private var model:Model;
        private var view:View;

        public function Main()
        {
            if (stage) {
                init(null);
            }
            else {
                addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
            }
        }

        public function init(event:Event=null):void
        {
            keyMouse = new KeyMouse();
            keyMouse.listen(stage);
            reset();
            inTrial = false;
            level = 1;
            LevelSelect.onSelect = load;
            LevelLoader.onLoaded = trial;
            model = new Model();
            view = new View();
            updateHudText();
            // trial();
            addEventListener(Event.ENTER_FRAME, update, false, 0, true);
            // level_txt.addEventListener(MouseEvent.CLICK, cheatLevel, false, 0, true);
            restartTrial_btn.addEventListener(MouseEvent.CLICK, restartTrial, false, 0, true);
            // API.connect(root, "", "");
        }

        private function onAirPocket(pocket:MovieClip):void
        {
            if (1 == pocket.currentFrame) {
                pocket.play();
                airPocket.play();
            }
        }

        private function cheatLevel(event:MouseEvent):void
        {
            level++;
            if (maxLevel < level) {
                level = 1;
            }
        }

        private function restartTrial(e:MouseEvent):void
        {
            reset();
            view.clear();
            next();
            // lose();
        }

        public function load(level:int):void
        {
            this.level = level;
            LevelLoader.load(level);
            select.play();
            gotoAndPlay("level");
            loopChannel = loop.play(0, int.MAX_VALUE);
        }

        public function trial():void
        {
            inTrial = true;
            mouseChildren = true;
            model.populate(level);
            view.populate(model, this);
        }

        internal function answer(correct:Boolean):void
        {
            answerClip.mouseChildren = false;
            answerClip.mouseEnabled = false;
            if (correct) {
                this.correct.play();
                answerClip.gotoAndPlay("correct");
            }
            else {
                this.wrong.play();
                answerClip.gotoAndPlay("wrong");
            }
        }

        private function updateHudText():void
        {
            // trace("updateHudText: ", score, highScore);
            score_txt.text = Model.score.toString();
            if (model) {
                levelScore_txt.text = model.levelScore.toString();
            }
            // score_txt.text = "12";
            // highScore_txt.text = Model.highScore.toString();
            // level_txt.text = level.toString();
            // maxLevel_txt.text = maxLevel.toString();
        }

        private function update(event:Event):void
        {
            var now:int = getTimer();
            keyMouse.update();
            // After stage is setup, connect to Kongregate.
            // http://flixel.org/forums/index.php?topic=293.0
            // http://www.photonstorm.com/tags/kongregate
            if (! FlxKongregate.hasLoaded && stage != null) {
                FlxKongregate.stage = stage;
                FlxKongregate.init(FlxKongregate.connect);
            }
            if (inTrial) {
                var win:int = model.update(now);
                view.update();
                result(win);
            }
            else {
                // view.update();
                if ("next" == feedback.currentLabel) {
                    next();
                }
            }
            updateHudText();
        }

        private function result(winning:int):void
        {
            if (!inTrial) {
                return;
            }
            if (winning <= -1) {
                lose();
            }
            else if (1 <= winning) {
                win();
            }
        }

        private function win():void
        {
            reset();
            inTrial = false;
            level++;
            if (maxLevel < level) {
                // level = 0;
                feedback.gotoAndPlay("complete");
                complete.play();
            }
            else {
                feedback.gotoAndPlay("correct");
                correct.play();
            }
            FlxKongregate.api.stats.submit("Score", Model.score);
            // API.postScore("Score", Model.score);
        }

        private function reset():void
        {
            if (null != loopChannel) {
                loopChannel.stop();
            }
        }

        private function lose():void
        {
            reset();
            inTrial = false;
            FlxKongregate.api.stats.submit("Score", Model.score);
            // API.postScore("Score", Model.score);
            mouseChildren = false;
            feedback.gotoAndPlay("wrong");
            wrong.play();
        }

        public function next():void
        {
            // feedback.gotoAndPlay("none");
            mouseChildren = true;
            restart();
        }

        public function restart():void
        {
            // level = 1;
            // trial();
            mouseChildren = true;
            gotoAndPlay(1);
        }
    }
}
