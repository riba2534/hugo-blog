---
title: LeetCode 98 验证二叉搜索树（递归，中序遍历）
date: 2020-05-05T01:03:00+08:00
lastmod: 2020-05-05T01:03:56+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[验证二叉搜索树](https://leetcode-cn.com/problems/validate-binary-search-tree/)

给定一个二叉树，判断其是否是一个有效的二叉搜索树。

假设一个二叉搜索树具有如下特征：

- 节点的左子树只包含**小于**当前节点的数。
- 节点的右子树只包含**大于**当前节点的数。
- 所有左子树和右子树自身必须也是二叉搜索树。

**示例 1:**

```
输入:
    2
   / \
  1   3
输出: true
```

**示例 2:**

```
输入:
    5
   / \
  1   4
     / \
    3   6
输出: false
解释: 输入为: [5,1,4,null,null,3,6]。
     根节点的值为 5 ，但是其右子节点值为 4 。
```

## 思路

方法一：

首先考虑递归的解法，要保证满足二叉搜索树的条件。需要保证左子树的每一个值都要小于当前节点，右子树的每一个值，都要大于当前节点。我们可以维护一个最小值和最大值的范围，当一个点满足小于最大值且大于最小值就是一颗BST。

方法二：

对这棵树进行一次中序遍历，如果是一颗BST，那么遍历结果肯定是一个递增的序列，我们检查一下这个序列是不是递增的即可。

## 代码

方法一：

```cpp
class Solution
{
public:
    bool dfs(TreeNode *root, long long minn, long long maxx)
    {
        if (!root)
            return true;
        // 只有当 root->val < maxx && root->val > minn 才有效
        if (root->val >= maxx || root->val <= minn)
            return false;
        return dfs(root->left, minn, root->val) && dfs(root->right, root->val, maxx);
    }
    bool isValidBST(TreeNode *root)
    {
        return dfs(root, LONG_MIN, LONG_MAX);
    }
};
```

方法二：

```cpp
class Solution
{
public:
    bool isValidBST(TreeNode *root)
    {
        stack<TreeNode *> st;
        //minn维护前一个的值，初始前一个没有值，初始化为无穷小
        long long minn = (long long)INT_MIN - 1;
        while (!st.empty() || root)
        {
            while (root)
            {
                st.push(root);
                root = root->left;
            }
            root = st.top();
            st.pop();
            // root的值必须大于前一个
            if (root->val <= minn)
                return false;
            minn = root->val;
            root = root->right;
        }
        return true;
    }
};
```
