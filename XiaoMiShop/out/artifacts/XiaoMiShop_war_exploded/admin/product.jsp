<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <script type="text/javascript">
        if ("${msg}" != "") {
            alert("${msg}");
        }
    </script>

    <c:remove var="msg"></c:remove>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bright.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/addBook.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <title></title>
</head>
<script type="text/javascript">
    /* 全选框*/
    function allClick() {
        //获取当前全选按钮的状态
        var isCheck = $("#all").prop("checked");
        //将此状态赋值给每个商品列表里的复选框（5），我们可以用遍历的方式去赋值
        $("input[name=ck]").each(
            function(){
                //通过遍历，为每个name为ck的input标签赋值为checked
                this.checked = isCheck;
            }
        );
    }
    /*单个复选框点击，会改变全选复选功能的实现*/
    function ckClick() {
        //获取所有的复选框的长度
        var fiveLength = $("input[name=ck]").length;
        //获取被选中的复选框的个数
        var checkedLength = $("input[name=ck]:checked").length;
        //判断，如果所有的复选框的个数和被选中的复选框的个数相同，那么就是全选，否则不是
        if(fiveLength == checkedLength){
            //单个的复选框全部被勾选，那么全选的复选框也勾选
            $("#all").prop("checked",true);
        }else{
            //单个的复选框中有最少一个没有被选中的复选框，那么全选也不能勾选
            $("#all").prop("checked",false);
        }
    }
</script>
<body>
<div id="brall">
    <div id="nav">
        <p>商品管理>商品列表</p>
    </div>
    <div id="condition" style="text-align: center">
        <form id="myform">
            商品名称：<input name="pname" id="pname">&nbsp;&nbsp;&nbsp;
            商品类型：<select name="typeid" id="typeid">
            <option value="-1">请选择</option>
            <c:forEach items="${ptlist}" var="pt">
                <option value="${pt.typeId}">${pt.typeName}</option>
            </c:forEach>
        </select>&nbsp;&nbsp;&nbsp;
            价格：<input name="lprice" id="lprice">-<input name="hprice" id="hprice">
            <input type="button" value="查询" onclick="ajaxsplit(${info.pageNum})">
        </form>
    </div>
    <br>
    <div id="table">

        <c:choose>
            <c:when test="${info.list.size()!=0}">

                <div id="top">
                    <input type="checkbox" id="all" onclick="allClick()" style="margin-left: 50px">&nbsp;&nbsp;全选
                    <a href="${pageContext.request.contextPath}/admin/addproduct.jsp">

                        <input type="button" class="btn btn-warning" id="btn1"
                               value="新增商品">
                    </a>
                    <input type="button" class="btn btn-warning" id="btn1"
                           value="批量删除" onclick="deleteBatch()">
                </div>
                <!--显示分页后的商品-->
                <div id="middle">
                    <table class="table table-bordered table-striped">
                        <tr>
                            <th></th>
                            <th>商品名</th>
                            <th>商品介绍</th>
                            <th>定价（元）</th>
                            <th>商品图片</th>
                            <th>商品数量</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${info.list}" var="p">
                            <tr>
                                <td valign="center" align="center">
                                    <input type="checkbox" name="ck" id="ck" value="${p.pId}" onclick="ckClick()"></td>
                                <td>${p.pName}</td>
                                <td>${p.pContent}</td>
                                <td>${p.pPrice}</td>
                                <td><img width="55px" height="45px"
                                         src="${pageContext.request.contextPath}/image_big/${p.pImage}"></td>
                                <td>${p.pNumber}</td>
                                    <%--<td><a href="${pageContext.request.contextPath}/admin/product?flag=delete&pid=${p.pId}" onclick="return confirm('确定删除吗？')">删除</a>--%>
                                    <%--&nbsp;&nbsp;&nbsp;<a href="${pageContext.request.contextPath}/admin/product?flag=one&pid=${p.pId}">修改</a></td>--%>
                                <td>
                                    <button type="button" class="btn btn-info "
                                            onclick="one(${p.pId})">编辑
                                    </button>
                                    <button type="button" class="btn btn-warning" id="mydel"
                                            onclick="del(${p.pId})">删除
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                    <!--分页栏-->
                    <div id="bottom">
                        <div>
                            <nav aria-label="..." style="text-align:center;">
                                <ul class="pagination">
                                    <li>
                                            <%--                                        <a href="${pageContext.request.contextPath}/prod/split.action?page=${info.prePage}" aria-label="Previous">--%>
                                        <a href="javascript:ajaxsplit(${info.prePage})" aria-label="Previous">

                                            <span aria-hidden="true">«</span></a>
                                    </li>
                                    <c:forEach begin="1" end="${info.pages}" var="i">
                                        <c:if test="${info.pageNum==i}">
                                            <li>
                                                    <%--                                                <a href="${pageContext.request.contextPath}/prod/split.action?page=${i}" style="background-color: grey">${i}</a>--%>
                                                <a href="javascript:ajaxsplit(${i})"
                                                   style="background-color: grey">${i}</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${info.pageNum!=i}">
                                            <li>
                                                    <%--                                                <a href="${pageContext.request.contextPath}/prod/split.action?page=${i}">${i}</a>--%>
                                                <a href="javascript:ajaxsplit(${i})">${i}</a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    <li>
                                        <%--  <a href="${pageContext.request.contextPath}/prod/split.action?page=1" aria-label="Next">--%>
                                        <a href="javascript:ajaxsplit(${info.nextPage})" aria-label="Next">
                                            <span aria-hidden="true">»</span></a>
                                    </li>
                                    <li style=" margin-left:150px;color: #0e90d2;height: 35px; line-height: 35px;">总共&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">${info.pages}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <c:if test="${info.pageNum!=0}">
                                            当前&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">${info.pageNum}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </c:if>
                                        <c:if test="${info.pageNum==0}">
                                            当前&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">1</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </c:if>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <h2 style="width:1200px; text-align: center;color: orangered;margin-top: 100px">暂时没有符合条件的商品！</h2>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>

<script type="text/javascript">
    function mysubmit() {
        $("#myform").submit();
    }

    //批量删除
    function deleteBatch() {
        //首先要获取到我们复选框都选中哪些
        var cks = $("input[name=ck]:checked");
        //为每个选中的id和str进行拼接，最后得到所有选中的复选框的ids字符串
        var str = "";
        var id = "";
        if (cks.length == 0){
            //没有选中任何复选框
            alert("请先选择要删除的商品！！！");
        } else {
            //有商品被选中了，那么我们就要获取到商品的一些数据，如id，然后对这些数据进行下一步的处理
            if (confirm("您确定删除"+cks.length + "条商品数据么？")){
                alert("可以删除的商品！！！");
                //对提交的要删除的商品的id进行字符串拼接
                $.each(cks,function () {
                    //获取选中的商品的id
                    id = $(this).val();
                    if (id !=null){
                        str += id + ","; //1,2,3,4,5
                    }
                });
                console.log(str);//只是为了测试用
                //获取到选中的所有商品信息的id，并完成拼接后，我们要发起一个ajax的请求
                $.ajax({
                    url:"${pageContext.request.contextPath}/prod/deleteBatch.action",
                    data:{"pids":str},
                    type:"post",
                    dataType:"text",
                    success:function (msg) {
                        //批量删除后，我们要显示删除的结果
                        alert(msg);//成功，失败，不可以删除
                        //重新进行局部刷新
                        $("#table").load("http://localhost:8081/admin/product.jsp #table")
                    }
                });
            }
        }
    }
    //单个删除
    function del(pid) {
        //删除的提示
        if(confirm("你确定删除么？")){
            //向服务器提交请求，完成删除工作
            $.ajax({
                url: "${pageContext.request.contextPath}/prod/delete.action",
                data: {"pid":pid},
                type: "post",
                dataType:"text",
                success:function (msg) {
                    alert(msg);
                    // 删除之后，刷新当前的表格，不刷新整个页面
                    $("#table").load("http://localhost:8081/admin/product.jsp #table");
                }
            })
        }
    }

    function one(pid) {
       location.href = "${pageContext.request.contextPath}/prod/one.action?pid="+pid;
    }
</script>
<!--分页的AJAX实现-->
<script type="text/javascript">
    function ajaxsplit(page) {
        //异步ajax分页请求
        //请求页page页中的所有数据，在当前页面上做局部刷新
        $.ajax({
            url:"${pageContext.request.contextPath}/prod/ajaxsplit.action",
            data:{"page":page},
            type:"post",
            success:function () {
                //重新加载分页显示的组件table
                $("#table").load("http://localhost:8081/admin/product.jsp #table");
            }
        })
    };

</script>

</html>