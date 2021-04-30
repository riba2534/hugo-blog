---
title: LeetCode 236 二叉树的最近公共祖先(递归)
date: 2020-05-10T01:00:01+08:00
lastmod: 2020-05-10T01:00:01+08:00
draft: false
featured_image: ""
tags:
- LeetCode
- 递归
categories: OnlineJudge刷题
comment: true

---

题目链接：[二叉树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/)

给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。

[百度百科](https://baike.baidu.com/item/最近公共祖先/8918834?fr=aladdin)中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（**一个节点也可以是它自己的祖先**）。”

例如，给定如下二叉树: root = [3,5,1,6,2,0,8,null,null,7,4]

![img](二叉树的最近公共祖先.assets/binarytree.png)

 

**示例 1:**

```
输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
输出: 3
解释: 节点 5 和节点 1 的最近公共祖先是节点 3。
```

**示例 2:**

```
输入: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
输出: 5
解释: 节点 5 和节点 4 的最近公共祖先是节点 5。因为根据定义最近公共祖先节点可以为节点本身。
```

 

**说明:**

- 所有节点的值都是唯一的。
- p、q 为不同节点且均存在于给定的二叉树中。

## 思路

乍一看是LCA的板子题，对于LCA问题，我们一般用 **离线tarjan**或者**在线倍增**来处理，或者用**树链剖分**

这几种算法，可以在我的ACM模板中找到 [最近公共祖先]([https://book.riba2534.cn/%E5%9B%BE%E8%AE%BA/%E6%9C%80%E8%BF%91%E5%85%AC%E5%85%B1%E7%A5%96%E5%85%88.html](https://book.riba2534.cn/图论/最近公共祖先.html)) 

但是这题只有一个查询，我们只需要用普通的递归来解决问题。

定义 $f_x$ 表示以 $x$ 为根的树中是否包含 $p$ 节点或者 $q$ 节点，则他们的最近公共祖先一定满足：

$$(f_{lson}\&\&f_{rson})||((x==p||x==q)\&\&({f_{lson}||f_{rson}})))$$

只要满足这个条件的点就是他们的公共祖先，那么能否保证这样找到的就是深度最小的祖先呢，dfs是自底向上的，所以最后一个满足条件的就是最近公共祖先。

## 代码

```cpp
struct TreeNode
{
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};

class Solution
{
public:
    TreeNode *ans;
    // root的子树中是否包含p或者q
    bool dfs(TreeNode *root, TreeNode *p, TreeNode *q)
    {
        if (!root)
            return false;
        bool lson = dfs(root->left, p, q);
        bool rson = dfs(root->right, p, q);
        if ((lson && rson) || ((root->val == q->val || root->val == p->val) && (lson || rson)))
            ans = root;
        return lson || rson || root->val == p->val || root->val == q->val;
    }
    TreeNode *lowestCommonAncestor(TreeNode *root, TreeNode *p, TreeNode *q)
    {
        dfs(root, p, q);
        return ans;
    }
};
```
