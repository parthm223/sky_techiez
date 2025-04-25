import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/services/ticket_service.dart';
import 'package:sky_techiez/services/comment_service.dart';
import 'package:sky_techiez/widgets/session_string.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailsScreen({
    super.key,
    required this.ticketData,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isCommentVisible = false;
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingComments = false;
  bool _hasCommentError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
        // Load comments when switching to comments tab
        if (_selectedTabIndex == 1) {
          _fetchComments();
        }
      });
    });

    // If we only have a ticket ID, fetch the full ticket data
    if (widget.ticketData.containsKey('id') && widget.ticketData.length < 5) {
      _fetchTicketDetails(widget.ticketData['id']);
      print(
          'njhebnvaebvfubrsbvbnjueb>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${widget.ticketData['id']}');
    }
  }

  Future<void> _fetchTicketDetails(String ticketId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ticket = await TicketService.getTicketById(ticketId);
      if (ticket != null) {
        setState(() {
          // Update the ticket data with the fetched details
          widget.ticketData.addAll(ticket.toJson());
          _isLoading = false;

          // Debug logging for subcategory
          if (widget.ticketData['sub_category_name'] != null) {
            print(
                'Ticket details has subcategory: ${widget.ticketData['sub_category_name']}');
          } else {
            print('Ticket details has no subcategory name');
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Ticket not found');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading ticket: $e');
    }
  }

  Future<void> _fetchComments() async {
    if (widget.ticketData['id'] == null) return;

    // Don't reload if already loading
    if (_isLoadingComments) return;

    setState(() {
      _isLoadingComments = true;
      _hasCommentError = false;
    });

    try {
      final comments =
          await CommentService.getComments(widget.ticketData['id'].toString());
      print(
          '${widget.ticketData}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoadingComments = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingComments = false;
          _hasCommentError = true;
        });
        _showErrorSnackBar('Unable to load comments. Please try again.');
        print('Error in _fetchComments: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            if (_selectedTabIndex == 1) {
              _fetchComments();
            } else if (widget.ticketData.containsKey('id')) {
              _fetchTicketDetails(widget.ticketData['id']);
            }
          },
          textColor: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleCommentField() {
    setState(() {
      _isCommentVisible = !_isCommentVisible;
    });
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty ||
        widget.ticketData['id'] == null) {
      return;
    }

    final comment = _commentController.text;
    final ticketId = widget.ticketData['id'].toString();

    // Disable the comment field while submitting
    setState(() {
      _isLoadingComments = true;
    });

    try {
      // Add retry logic
      bool success = false;
      int retryCount = 0;

      while (!success && retryCount < 2) {
        success = await CommentService.addComment(ticketId, comment);

        if (!success) {
          retryCount++;
          // Wait a moment before retrying
          if (retryCount < 2) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
      }

      if (success) {
        // Clear the comment field first
        setState(() {
          _commentController.clear();
          _isCommentVisible = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment added successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh comments after adding a new one
        await _fetchComments();
      } else {
        setState(() {
          _isLoadingComments = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to add comment. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _addComment,
              textColor: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoadingComments = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.white,
                expandedHeight: 660,
                pinned: true,
                floating: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: innerBoxIsScrolled
                    ? Text(
                        widget.ticketData['subject'] ?? 'Ticket Details',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                    color: AppColors.cardBackground,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Add the logo at the top
                          Center(
                            child: Image.asset(
                              'assets/images/SkyLogo.png',
                              height: 120,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.ticketData['subject'] ??
                                'No subject provided',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.cardBackground,
                      border: Border(
                        bottom:
                            BorderSide(color: AppColors.lightGrey, width: 1),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryBlue,
                      indicatorWeight: 3,
                      labelColor: AppColors.primaryBlue,
                      unselectedLabelColor: AppColors.grey,
                      tabs: const [
                        Tab(text: 'PROGRESS'),
                        Tab(text: 'COMMENTS'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // PROGRESS Tab
              Container(
                color: AppColors.cardBackground,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProgressItem('New ticket', true),
                      if (widget.ticketData['status'] != 'Completed' &&
                          widget.ticketData['status'] != 'Resolved') ...[
                        _buildProgressItem('Acknowledged by Support',
                            widget.ticketData['status'] != 'New'),
                        _buildProgressItem('Assigned to Technician',
                            widget.ticketData['status'] == 'In Progress'),
                        _buildProgressItem('In Progress',
                            widget.ticketData['status'] == 'In Progress'),
                        _buildProgressItem('Resolved', false, isLast: true),
                      ] else if (widget.ticketData['status'] == 'Resolved') ...[
                        _buildProgressItem('Acknowledged by Support', true),
                        _buildProgressItem('Assigned to Technician', true),
                        _buildProgressItem('In Progress', true),
                        _buildProgressItem('Resolved', true, isLast: true),
                      ] else ...[
                        _buildProgressItem('Acknowledged by Support', true),
                        _buildProgressItem('Assigned to Technician', true),
                        _buildProgressItem('In Progress', true),
                        _buildProgressItem('Resolved', true, isLast: true),
                      ],
                    ],
                  ),
                ),
              ),

              // COMMENTS Tab
              Container(
                color: AppColors.cardBackground,
                child: _isCommentVisible
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _commentController,
                              maxLines: 3,
                              style: const TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                hintText: 'Add your comment here...',
                                hintStyle:
                                    const TextStyle(color: AppColors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.lightGrey),
                                ),
                                filled: true,
                                fillColor: AppColors.cardBackground,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCommentVisible = false;
                                      _commentController.clear();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.white,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed:
                                      _isLoadingComments ? null : _addComment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    foregroundColor: AppColors.white,
                                  ),
                                  child: _isLoadingComments
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.white,
                                          ),
                                        )
                                      : const Text('Submit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : _isLoadingComments
                        ? const Center(child: CircularProgressIndicator())
                        : _hasCommentError
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Failed to load comments',
                                      style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: _fetchComments,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryBlue,
                                      ),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : _comments.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.comment_outlined,
                                          color: AppColors.grey,
                                          size: 48,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No comments yet',
                                          style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: _toggleCommentField,
                                          child: const Text(
                                            'Add a comment',
                                            style: TextStyle(
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: _fetchComments,
                                    color: AppColors.primaryBlue,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: _comments.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          // System comment
                                          return _buildChatBubble(
                                            'Support Team',
                                            'Your ticket has been received. Our team will review it shortly.',
                                            isUserComment: false,
                                          );
                                        }
                                        final comment = _comments[index - 1];
                                        final isUserComment = GetStorage()
                                                .read(userCollectionName)["id"]
                                                .toString() ==
                                            comment['user_id'].toString();
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Align(
                                            alignment: GetStorage()
                                                        .read(userCollectionName)[
                                                            "id"]
                                                        .toString() ==
                                                    comment['user_id']
                                                        .toString()
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            child: _buildChatBubble(
                                              isUserComment
                                                  ? 'You'
                                                  : 'Support Team',
                                              comment['comment'] ?? '',
                                              isUserComment: isUserComment,
                                              timestamp: comment['created_at'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton:
          _selectedTabIndex == 1 && !_isCommentVisible && !_isLoadingComments
              ? FloatingActionButton(
                  backgroundColor: AppColors.primaryBlue,
                  onPressed: _toggleCommentField,
                  elevation: 4,
                  child: const Icon(Icons.add_comment, color: AppColors.white),
                )
              : null,
    );
  }

  Widget _buildInfoCard() {
    // Format date to be more readable
    String formattedDate = widget.ticketData['date'] ?? '';
    try {
      if (formattedDate.contains('T')) {
        final dateTime = DateTime.parse(formattedDate);
        formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      // Use original date if parsing fails
    }

    return Card(
        color: AppColors.cardBackground.withOpacity(0.7),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: AppColors.primaryBlue.withOpacity(0.3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ticket ${widget.ticketData['ticket_id'] ?? ''}',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusBadge(widget.ticketData['status'] ?? 'New'),
                ],
              ),
              const Divider(color: AppColors.lightGrey, height: 24),
              _buildInfoRow('Assigned to', 'Support Team'),
              _buildInfoRow(
                  'Category',
                  widget.ticketData['category_name'] ??
                      widget.ticketData['category'] ??
                      'General Support'),
              if (widget.ticketData['sub_category_name'] != null)
                _buildInfoRow(
                    'Subcategory', widget.ticketData['sub_category_name']),
              if (widget.ticketData['sub_category_name'] == null &&
                  widget.ticketData['technicalSupportType'] != null)
                _buildInfoRow('Technical Support Type',
                    widget.ticketData['technicalSupportType']),
              _buildInfoRow(
                  'Priority', widget.ticketData['priority'] ?? 'Medium'),
              _buildInfoRow('Date', formattedDate),
              const Divider(color: AppColors.lightGrey, height: 24),
              const Text(
                'Description',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.ticketData['description'] ?? 'No description provided',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if ((widget.ticketData['description'] ?? '').length > 100)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Show full description in a dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.cardBackground,
                          title: const Text(
                            'Full Description',
                            style: TextStyle(color: AppColors.white),
                          ),
                          content: SingleChildScrollView(
                            child: Text(
                              widget.ticketData['description'] ?? '',
                              style: const TextStyle(color: AppColors.white),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Read More',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ),
              // Show attachment if available
              if (widget.ticketData['attachment_url'] != null &&
                  widget.ticketData['attachment_url'].toString().isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.lightGrey),
                    const SizedBox(height: 8),
                    const Text(
                      'Attachment',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        // Open attachment (would need to implement a viewer)
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_file,
                                color: AppColors.primaryBlue, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'View Attachment',
                                style: const TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modified chat bubble implementation - swapped alignment
  Widget _buildChatBubble(String author, String content,
      {required bool isUserComment, String? timestamp}) {
    // Format timestamp if available
    String formattedTime = 'Just now';
    if (timestamp != null) {
      try {
        final dateTime = DateTime.parse(timestamp);
        final now = DateTime.now();
        final difference = now.difference(dateTime);

        if (difference.inDays > 365) {
          formattedTime = '${(difference.inDays / 365).floor()} years ago';
        } else if (difference.inDays > 30) {
          formattedTime = '${(difference.inDays / 30).floor()} months ago';
        } else if (difference.inDays > 0) {
          formattedTime = '${difference.inDays} days ago';
        } else if (difference.inHours > 0) {
          formattedTime = '${difference.inHours} hours ago';
        } else if (difference.inMinutes > 0) {
          formattedTime = '${difference.inMinutes} minutes ago';
        }
      } catch (e) {
        // Use default if parsing fails
      }
    }

    // MODIFIED: Swapped alignment - user comments on left, support team on right
    return Row(
      mainAxisAlignment:
          isUserComment ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUserComment) ...[
          CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 16,
            child: const Icon(
              Icons.person,
              color: AppColors.cardBackground,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUserComment
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUserComment
                      ? AppColors.primaryBlue.withOpacity(0.2)
                      : AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUserComment ? 4 : 16),
                    bottomRight: Radius.circular(isUserComment ? 16 : 4),
                  ),
                  border: Border.all(
                    color: isUserComment
                        ? AppColors.primaryBlue.withOpacity(0.3)
                        : AppColors.primaryBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUserComment
                            ? AppColors.primaryBlue
                            : AppColors.primaryBlue,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                child: Text(
                  formattedTime,
                  style: TextStyle(
                    color: AppColors.grey.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isUserComment) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue,
            radius: 16,
            child: const Icon(
              Icons.support_agent,
              color: AppColors.white,
              size: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    if (status.toLowerCase() == 'in progress') {
      statusColor = Colors.blue;
    } else if (status.toLowerCase() == 'pending') {
      statusColor = Colors.orange;
    } else if (status.toLowerCase() == 'completed' ||
        status.toLowerCase() == 'resolved') {
      statusColor = Colors.green;
    } else if (status.toLowerCase() == 'new') {
      statusColor = Colors.purple;
    } else {
      statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildProgressItem(String text, bool isCompleted,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primaryBlue : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primaryBlue : AppColors.grey,
                  width: 2,
                ),
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.access_time,
                color: isCompleted ? AppColors.white : AppColors.grey,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? AppColors.primaryBlue
                    : AppColors.grey.withOpacity(0.5),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isCompleted ? AppColors.white : AppColors.grey,
                  fontSize: 16,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isLast
                        ? 'Completed on ${widget.ticketData['date'] ?? 'today'}'
                        : 'Updated on ${widget.ticketData['date'] ?? 'today'}',
                    style: TextStyle(
                      color: AppColors.grey.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              SizedBox(height: isLast ? 0 : 20),
            ],
          ),
        ),
      ],
    );
  }
}
