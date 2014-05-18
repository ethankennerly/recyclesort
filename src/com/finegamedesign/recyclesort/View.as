package com.finegamedesign.recyclesort
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import com.greensock.TweenLite;

    public class View
    {
        private static var itemClasses:Object = {
            landfill:   ItemLandfill,
            recycle:   ItemRecycle
        }

        internal var main:Main;
        internal var onCorrect:Function;
        internal var model:Model;
        private var queue:Array;
        private var garbage:Array;

        public function View()
        {
        }

        internal function populate(model:Model, main:Main):void
        {
            this.model = model;
            this.main = main;
            populateQueue(model.queue);
        }

        private function populateQueue(queueModel:Array):void
        {
            queue = [];
            garbage = [];
            for (var i:int = 0; i < queueModel.length; i++) {
                var itemClass:Class = itemClasses[queueModel[i]];
                var item:DisplayObjectContainer = new itemClass();
                item.x = main.input.head.x;
                item.y = main.input.head.y - (i * main.input.head.height);
                item.mouseChildren = false;
                item.mouseEnabled = false;
                queue.push(item);
                garbage.push(item);
                main.input.addChildAt(item,
                    main.input.getChildIndex(main.input.head));
            }
        }

        private function shift(target:DisplayObject):void
        {
            for each(var item:DisplayObject in queue) {
                TweenLite.to(item, 0.2, {x: target.x, y: target.y});
                target = item;
            }
            queue.shift();
        }

        private function answer(name:String):void
        {
            main.answer(model.answer(name));
            shift(main.input[name]);
        }

        internal function update():void
        {
            if (main.keyMouse.justPressed("LEFT")) {
                answer("landfill");
            }
            else if (main.keyMouse.justPressed("RIGHT")) {
                answer("recycle");
            }
            if (main.keyMouse.justPressed("MOUSE")) {
                var name:String = main.keyMouse.target.name;
                if (name in itemClasses) {
                    answer(name);
                }
            }
        }

        internal function clear():void
        {
            for each(var item:DisplayObject in garbage) {
                if (garbage.parent) {
                    garbage.parent.remove(garbage);
                }
            }
            if (model) {
                model.clear();
            }
        }
    }
}
