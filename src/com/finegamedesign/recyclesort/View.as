package com.finegamedesign.recyclesort
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import com.greensock.TweenLite;

    public class View
    {
        internal var main:Main;
        internal var onCorrect:Function;
        internal var model:Model;
        private var isMouseDown:Boolean;
        private var mouseJustPressed:Boolean;
        private var queue:Array;

        public function View()
        {
        }

        internal function populate(model:Model, main:Main):void
        {
            this.model = model;
            this.main = main;
            main.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
            // main.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            main.input.landfill.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            main.input.recycle.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            populateQueue(model.queue);
        }

        private static var itemClasses:Object = {
            landfill:   ItemLandfill,
            recycle:   ItemRecycle
        };

        private function populateQueue(queueModel:Array):void
        {
            queue = [];
            for (var i:int = 0; i < queueModel.length; i++) {
                var itemClass:Class = itemClasses[queueModel[i]];
                var item:DisplayObjectContainer = new itemClass();
                item.x = main.input.head.x;
                item.y = main.input.head.y - (i * main.input.head.height);
                item.mouseChildren = false;
                item.mouseEnabled = false;
                queue.push(item);
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

        private function mouseDown(event:MouseEvent):void
        {
            mouseJustPressed = !isMouseDown;
            if (mouseJustPressed) {
                var name:String = event.currentTarget.name;
                if (model.answer(name)) {
                    main.correct.play();
                }
                else {
                    main.wrong.play();
                }
                shift(DisplayObject(event.currentTarget));
            }
            isMouseDown = true;
        }

        private function mouseUp(event:MouseEvent):void
        {
            mouseJustPressed = false;
            isMouseDown = false;
        }

        internal function update():void
        {
        }

        internal function clear():void
        {
            if (model) {
                model.clear();
            }
        }
    }
}
