//shiny output binding
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  return $(scope).find(".collapsableForceNetwork");
};


binding.renderValue = function(el, data) {
  //empty the div so that it removes the graph when you change data
  $(el).empty()
  
  if(data!=null){

    var width = 960*1.5,
      height = 500*2,
      root;

    var force = d3.layout.force()
      .size([width, height])
      .on("tick", tick);

    var svg = d3.select("#" + $(el).attr('id')).append("svg")
      .attr("width", width)
      .attr("height", height);

    var link = svg.selectAll(".link"),
      node = svg.selectAll(".node");

    d3.json("kinome_tree.json", function(error, json) {
      if (error) throw error;

      root = json;
      update();
    });

    function update() {
        var nodes = flatten(root),
        links = d3.layout.tree().links(nodes);

      // Restart the force layout.
      force
        .nodes(nodes)
        .links(links)
        .start();

      // Update the links…
      link = link.data(links, function(d) { return d.target.id; });

      // Exit any old links.
      link.exit().remove();

      // Enter any new links.
      link.enter().insert("line", ".node")
        .attr("class", "link")
        .attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

      // Update the nodes…
      node = node.data(nodes, function(d) { return d.id; }).style("fill", color);

      // Exit any old nodes.
      node.exit().remove();

      // Enter any new nodes.
      node.enter().append("circle")
       .attr("class", "node")
       .attr("cx", function(d) { return d.x; })
       .attr("cy", function(d) { return d.y; })
       .attr("r", function(d) { return Math.sqrt(d.size) / 10 || 4.5; })
       .style("fill", color)
       .on("click", click)
       .call(force.drag);
    }

    function tick() {
      link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

      node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
    }

    // Color leaf nodes orange, and packages white or blue.
    function color(d) {
     return d._children ? "#3182bd" : d.children ? "#c6dbef" : "#fd8d3c";
    }

    // Toggle children on click.
    function click(d) {
      if (!d3.event.defaultPrevented) {
        if (d.children) {
          d._children = d.children;
          d.children = null;
        } else {
           d.children = d._children;
           d._children = null;
        }
        update();
      }
    }

    // Returns a list of all nodes under the root.
    function flatten(root) {
      var nodes = [], i = 0;

      function recurse(node) {
        if (node.children) node.children.forEach(recurse);
        if (!node.id) node.id = ++i;
        nodes.push(node);
      }

      recurse(root);
      return nodes;
    }
  //closing if statement
  }
//closing binding  
};

//register the output binding
Shiny.outputBindings.register(binding, "collapsableForceNetwork");
