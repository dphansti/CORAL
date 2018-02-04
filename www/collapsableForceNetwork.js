//shiny output binding
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  return $(scope).find(".collapsableForceNetwork");
};


binding.renderValue = function(el, data) {
  //empty the div so that it removes the graph when you change data
  $(el).empty()
  
  if(data!=null){

      var width = 940,
          height = 800,
          root;

      var force = d3.layout.force()
          .linkDistance(.25)
          .charge(-40)
          .gravity(.2)
          .size([width, height])
          .on("tick", tick);

      var svg = d3.select("#" + $(el).attr('id')).append("svg")
          .attr("width", width)
          .attr("height", height)
          .call(d3.behavior.zoom().on("zoom", redraw));

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
        

        // Update links.
        link = link.data(links, function(d) { return d.target.id; });

        link.exit().remove();

        link.enter().insert("line", ".node")
            .attr("class", "link");

        // Update nodes.
        node = node.data(nodes, function(d) { return d.id; });

        node.exit().remove();

        var nodeEnter = node.enter().append("g")
            .attr("class", "node")
            .on("click", click)
            .call(force.drag);

        nodeEnter.append("circle")
            .attr("r", function(d) { return (d.noderadius * 2.5); })
            

        nodeEnter.append("text")
            .attr("dy", ".35em")
            .text(function(d) { return d.name; });

        node.select("circle")
            .style("fill", function(d) { return d3.rgb(d.nodecol); });
      }

      function tick() {
        link.attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });

        node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
      }

      function color(d) {
        return d._children ? "#3182bd" // collapsed package
            : d.children ? "#c6dbef" // expanded package
            : "#fd8d3c"; // leaf node
      }

      // Toggle children on click.
      function click(d) {
        if (d3.event.defaultPrevented) return; // ignore drag
        if (d.children) {
          d._children = d.children;
          d.children = null;
        } else {
          d.children = d._children;
          d._children = null;
        }
        update();
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

      function redraw() {
        console.log("here", d3.event.translate, d3.event.scale); svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")");
      }
  //closing if statement
  }
//closing binding  
};

//register the output binding
Shiny.outputBindings.register(binding, "collapsableForceNetwork");
