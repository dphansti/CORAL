//shiny output binding
var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  return $(scope).find(".circleNetwork");
};

binding.renderValue = function(el, data) {
  //empty the div so that it removes the graph when you change data
  $(el).empty();

  if(data!=null){
    //////////.JS//////////
    var radius = 400;
      width = 940,
      height = 940;

    var cluster = d3.layout.cluster()
        .size([360, radius - 60]);

    var diagonal = d3.svg.diagonal.radial()
      .projection(function(d) { return [d.y, d.x / 180 * Math.PI]; });

    var mainsvg = d3.select("#" + $(el).attr('id')).append("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("xmlns","http://www.w3.org/2000/svg");

    var rtx = radius + 70,
        rty = radius;

    var svg = mainsvg
      .append("g")
      .attr("transform", "translate(" + rtx + "," + rty + ")");	

    var zoom = d3.behavior.zoom()
      .scaleExtent([1, 10])
      .translate([rtx, rty])
      .on("zoom", function() {
        var e = d3.event,
            tx = e.translate[0]
            ty = e.translate[1];
        zoom.translate([tx, ty]);
        svg.attr(
          "transform",
          "translate(" + [tx, ty] + ")" + " scale(" + e.scale + ")"
        );
    });
    mainsvg.call(zoom);

    d3.json($(el).attr('jsonfilename'), function(error, root) {

      var nodes = cluster.nodes(root);

      var link = svg.selectAll("path.link")
          .data(cluster.links(nodes))
          .enter().append("path")
          .attr("class", "link")
          .attr("d", diagonal)
          .attr("stroke-width", 1.5)
          .attr("stroke", function(d) { return d3.rgb(d.target.branchcol); })
          .attr("fill","none")
          .attr("pointer-events","none");

      var node = svg.selectAll("g.node")
          .data(nodes)
          .enter().append("g")
          .attr("class", "node")
          .attr("stroke-width", 1.5)
          .attr("stroke", "white")
          .attr("transform", function(d) { return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")"; })
          .on("mouseover", mouseover)
          .on("mouseout", mouseout);

      node.append("circle")
          .attr("r", function(d) { return d.noderadius; })
          .attr("stroke",function(d) { return d3.rgb(d.nodestrokecol); })
          .attr("stroke-width", 0.5)
          .attr("opacity",function(d) { return d.nodeopacity; })
          .attr("fill", function(d) { return d3.rgb(d.nodecol); });


      node.append("text")
          .attr("dy", ".31em")
          .attr("font-family","Helvetica")
          .attr("font-color","black")
          .attr("stroke-width", 0.0)
          .attr("font-size",function(d) { return d.textsize; })
          .attr("text-anchor", function(d) { return d.x < 180 ? "start" : "end"; })
          .attr("transform", function(d) { return d.x < 180 ? "translate(8)" : "rotate(180)translate(-8)"; })
          .text(function(d) { return d.name; });

      // Create pseudo-element with the legend and add it to the SVG
      $(el).find('svg #circlelegend').remove();
      if(root.legend) {
        var pseudoSVG = $(
          '<div>' +
          '<svg xmlns="http://www.w3.org/2000/svg">' +
          '<g id="circlelegend">'+ root.legend + '</g>' + 
          '</svg>' +
          '</div>'
        );
        $(el).find('svg').append(pseudoSVG.find('svg g'));
      }
    });

    function mouseover() {
      d3.select(this).select("circle").transition()
          .attr("r", 20);
      d3.select(this).select("text").transition()
          .attr("font-size", "40px");
    }

    function mouseout() {
      d3.select(this).select("circle").transition()
          .attr("r", function(d) { return d.noderadius; });
      d3.select(this).select("text").transition()
          .attr("font-size", function(d) { return d.textsize; });
    }


    d3.select(self.frameElement).style("height", radius * 2 + "px");

    // Code to download svg
    // Code adapted from (http://bl.ocks.org/duopixel/3831266)
     d3.select("#downloadcircle").on("click", function(){
       d3.select(this)
        .attr("href", 'data:application/octet-stream;base64,' + btoa(unescape(encodeURIComponent(d3.select("#circlelayout").html().replace("&nbsp;", "")))))
        .attr("download", "CORAL.circle.svg") ;
    });

    //////////.JS//////////

    //closing if statement
  }
  //closing binding
};

//Identify the class that this js modifies below in ....(binding, "CLASSNAME");....
//register the output binding
Shiny.outputBindings.register(binding, "circleNetwork");
