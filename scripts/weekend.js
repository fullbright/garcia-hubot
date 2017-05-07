// Description:
//   holiday detector script
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   hubot is it weekend ?  - returns whether is it weekend or not
//   hubot is it holiday ?  - returns whether is it holiday or not

b3 = {}
b3new = require('../b3core.0.1.0.js');

module.exports = function(robot) {
    robot.respond(/is it (weekend|holiday)\s?\?/i, function(msg){
        var today = new Date();

        msg.reply(today.getDay() === 0 || today.getDay() === 6 ? "YES" : "NO");

        console.log(b3.VERSION);

        var MyCustomClass = b3.Class();
        var custom = new MyCustomClass(); // will call initialize.
        var StringShorterer = b3.Class(b3.Action);
        var StringAppender = b3.Class(b3.Action);
        StringShorterer.prototype.name = "StringShorterer";
        StringAppender.prototype.name = "StringAppender";

        var blackboard = new b3.Blackboard();
        var tree = new b3.BehaviorTree();
        var node = new StringShorterer();
        var node2 = new StringAppender();
        var target = "this is a pseudo random string"

        tree.root = new b3.Sequence({children: [
            new b3.Sequence({children: [
                new StringShorterer(),
                new StringAppender(),
                new StringShorterer(),
                new StringShorterer()
            ]}),
        ]});

        StringShorterer.prototype.tick = function(tick)
        {
            console.log("StringShorterer . before: " + tick.target);
            tick.target = tick.target + "a";
            console.log("StringShorterer . after : " + tick.target);
            return b3.SUCCESS;
        }

        StringAppender.prototype.tick = function(tick)
        {
            console.log("StringAppender . before: " + tick.target);
            tick.target = tick.target.substring(4);
            console.log("StringAppender . after : " + tick.target);
            return b3.SUCCESS;
        }

        // getting/setting variable in global context
        blackboard.set('test-global', 'this is a global value');
        var value = blackboard.get('test-global');
        console.log(value);

        // getting/setting variable in per tree context
        blackboard.set('test-treevariable', 'this value is stored in the tree', tree.id);
        var value = blackboard.get('test-treevariable', tree.id);
        console.log(value);

        // getting/setting variable in per node per tree context
        blackboard.set('test-nodevariable', 'my node variable', tree.id, node.id);
        var value = blackboard.get('test-nodevariable', tree.id, node.id);
        console.log(value);

        //for (var i = 10 - 1; i >= 0; i--) 
        //{
            tree.tick(target, blackboard);
        //}

    });
}

