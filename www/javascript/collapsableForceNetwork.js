
//shiny output binding
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  return $(scope).find(".collapsableForceNetwork");
};

binding.renderValue = function(el, data) {
  //empty the div so that it removes the graph when you change data
  $(el).empty();

  if(data!=null){

      var width = 940,
          height = 800,
          root;

      var force = d3.layout.force()
          .linkDistance(0.25)
          .charge(-40)
          .gravity(0.2)
          .size([width, height])
          .on("tick", tick);

      var svg = d3.select("#" + $(el).attr('id')).append("svg")
          .attr("width", width)
          .attr("height", height)
          .attr("xmlns","http://www.w3.org/2000/svg")
          .call(
            d3.behavior.zoom()
            .scaleExtent([1, 5])
            .on("zoom", function() {
              svg.attr(
                "transform",
                "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")"
              );
            })
	  );

      function redraw() {
        svg.attr("transform", "translate(" + d3.event.translate + ")" + " scale(" + d3.event.scale + ")");
      }

      var link = svg.selectAll(".link");
          node = svg.selectAll(".node");

      d3.json($(el).attr('jsonfilename'), function(error, json) {
        if (error) throw error;

        root = json;
        update();

      });

    function mouseover() {
      d3.select(this).select("circle").transition()
           .attr("r", function(d) { return (d.noderadius * 5); });
      d3.select(this).select("text").transition()
          .attr("font-size", function(d) { return (d.textsize * 10.0 + "px"); });
    }

    function mouseout() {
      d3.select(this).select("circle").transition()
           .attr("r", function(d) { return (d.noderadius * 1.5); });
      d3.select(this).select("text").transition()
          .attr("font-size", function(d) { return (d.textsize * 1.75 + "px"); });
    }


      // Code to download svg
     d3.select("#downloadforce").on("click", function(){
       d3.select(this)
        .attr("href", 'data:application/octet-stream;base64,' + btoa(unescape(encodeURIComponent(d3.select("#forcelayout").html().replace("&nbsp;", "")))))
        .attr("download", "CORAL.force.svg") ;
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

        nodeEnter.append("circle")
            .attr("r", function(d) { return d.noderadius * 1.5; });

        nodeEnter.append("text")
            .attr("dy", ".35em")
            .attr("font-family","Helvetica")
            .attr("text-anchor","middle")
            .text(function(d) { return d.name; })
            .attr("font-size", function(d) { return ((d.textsize * 1.75) + "px"); });

        nodeEnter.select("circle")
            .attr("fill", function(d) { return d3.rgb(d.nodecol); })
            .attr("stroke-width", 1.0)
            .attr("opacity",function(d) { return d.nodeopacity; })
            .attr("stroke",function(d) { return d3.rgb(d.nodestrokecol); });

        // Create pseudo-element with the legend and add it to the SVG
        $(el).find('svg #forcelegend').remove();
        var pseudoSVG = $(
          '<div>' +
          '<svg xmlns="http://www.w3.org/2000/svg">' +
          '<g id="forcelegend">'+ root.legend + '</g>' + 
          '</svg>' +
          '</div>'
        );
        $(el).find('svg').append(pseudoSVG.find('svg g'));
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

  //closing if statement
  }
//closing binding
};

//register the output binding
Shiny.outputBindings.register(binding, "collapsableForceNetwork");
