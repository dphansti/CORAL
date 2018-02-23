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
          .attr("xmlns","http://www.w3.org/2000/svg")
          .call(d3.behavior.zoom().on("zoom", redraw));

      var link = svg.selectAll(".link")
          node = svg.selectAll(".node");

      d3.json("kinome_tree.json", function(error, json) {
        if (error) throw error;

        root = json;
        update();  
    
      });
      
    function mouseover() {
      d3.select(this).select("circle").transition()
           .attr("r", function(d) { return (d.noderadius * 5); })
      d3.select(this).select("text").transition()
          .attr("font-size", function(d) { return (d.textsize * 10.0 + "px"); })
      d3.select(this).moveToFront();
    }

    function mouseout() {
      d3.select(this).select("circle").transition()
           .attr("r", function(d) { return (d.noderadius * 1.5); })
      d3.select(this).select("text").transition()
          .attr("font-size", function(d) { return (d.textsize * 2.0 + "px"); })
      d3.select(this).moveToFront();
    }


      // Code to download svg
     d3.select("#downloadforce").on("click", function(){
       d3.select(this)
        .attr("href", 'data:application/octet-stream;base64,' + btoa(d3.select("#forcelayout").html()))
        .attr("download", "CORAL.force.svg") 
    })


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
            .attr("class", "link")
            .attr("stroke-width", 1.5)
            .attr("stroke", function(d) { return d3.rgb(d.target.branchcol); })
            .attr("fill","none");

        // Update nodes.
        node = node.data(nodes, function(d) { return d.id; });

        node.exit().remove();

        var nodeEnter = node.enter().append("g")
            .attr("class", "node")
            //.on("click", click)
            .call(force.drag)
            .on("mouseover", mouseover)
            .on("mouseout", mouseout);

        node.append("circle")
            .attr("r", function(d) { return (d.noderadius * 1.5); })
            
        node.append("text")
            .attr("dy", ".35em")
            .attr("text-anchor","middle")
            .text(function(d) { return d.name; })
            .attr("font-size", function(d) { return ((d.textsize * 2) + "px"); });

        node.select("circle")
            .style("fill", function(d) { return d3.rgb(d.nodecol); })
            .attr("stroke-width", 1.0)
            .attr("stroke","white");
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
